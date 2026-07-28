import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/models/inventory_item.dart';
import '../models/stocktake_line.dart';
import '../models/stocktake_session.dart';
import 'stocktake_repository_base.dart';
import 'stocktake_repository_failure.dart';

class StocktakeRepository implements StocktakeRepositoryBase {
  static const _stocktakeCounterId = 'stocktakeNumber';
  static const _adjustmentCounterId = 'stocktakeAdjustmentVoucher';
  static const _maximumSessionItems = 450;
  static const _maximumAdjustmentItems = 50;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  StocktakeRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  }) : _firestore = firestore,
       _firebaseAuth = firebaseAuth;

  CollectionReference<Map<String, dynamic>> get _items =>
      _firestore.collection(FirestoreCollections.items);

  CollectionReference<Map<String, dynamic>> get _movements =>
      _firestore.collection(FirestoreCollections.movements);

  CollectionReference<Map<String, dynamic>> get _stocktakes =>
      _firestore.collection(FirestoreCollections.stocktakes);

  CollectionReference<Map<String, dynamic>> get _counters =>
      _firestore.collection(FirestoreCollections.counters);

  @override
  Future<StocktakeSession?> fetchOpenStocktake() async {
    try {
      final snapshot = await _stocktakes
          .where('status', isEqualTo: 'open')
          .limit(1)
          .get();
      if (snapshot.docs.isEmpty) {
        return null;
      }
      final document = snapshot.docs.single;
      return _mapSession(id: document.id, data: document.data());
    } on FirebaseException catch (error) {
      throw StocktakeRepositoryFailure(_readFailureMessage(error));
    } on FormatException {
      throw const StocktakeRepositoryFailure(
        'بيانات جلسة الجرد المفتوحة غير صالحة.',
      );
    }
  }

  @override
  Stream<List<StocktakeLine>> watchLines(String stocktakeId) async* {
    try {
      await for (final snapshot
          in _stocktakes
              .doc(stocktakeId)
              .collection(FirestoreCollections.stocktakeLines)
              .orderBy('itemNameSnapshot')
              .snapshots()) {
        yield snapshot.docs
            .map(
              (document) =>
                  _mapLine(itemId: document.id, data: document.data()),
            )
            .toList(growable: false);
      }
    } on FirebaseException catch (error) {
      throw StocktakeRepositoryFailure(_readFailureMessage(error));
    } on FormatException {
      throw const StocktakeRepositoryFailure(
        'بيانات أحد أصناف جلسة الجرد غير صالحة.',
      );
    }
  }

  @override
  Future<StocktakeSession> startStocktake(StartStocktakeDraft draft) async {
    final user = _requireUser();
    final openSession = await _stocktakes
        .where('status', isEqualTo: 'open')
        .limit(1)
        .get();
    if (openSession.docs.isNotEmpty) {
      throw const StocktakeRepositoryFailure(
        'توجد جلسة جرد مفتوحة بالفعل. أكملها قبل بدء جلسة جديدة.',
      );
    }

    final activeItemsSnapshot = await _items
        .where('active', isEqualTo: true)
        .get();
    if (activeItemsSnapshot.docs.isEmpty) {
      throw const StocktakeRepositoryFailure(
        'لا توجد أصناف نشطة لبدء جلسة الجرد.',
      );
    }
    if (activeItemsSnapshot.docs.length > _maximumSessionItems) {
      throw const StocktakeRepositoryFailure(
        'عدد الأصناف أكبر من الحد الآمن لجلسة واحدة. تواصل مع مسؤول النظام.',
      );
    }

    final stocktakeReference = _stocktakes.doc();
    final counterReference = _counters.doc(_stocktakeCounterId);

    try {
      return await _firestore.runTransaction((transaction) async {
        final counterSnapshot = await transaction.get(counterReference);
        final itemSnapshots = <DocumentSnapshot<Map<String, dynamic>>>[];
        for (final itemDocument in activeItemsSnapshot.docs) {
          itemSnapshots.add(await transaction.get(itemDocument.reference));
        }

        final activeItems = itemSnapshots
            .where((snapshot) => snapshot.exists)
            .map(
              (snapshot) => InventoryItem.fromMap(
                id: snapshot.id,
                data: snapshot.data()!,
              ),
            )
            .where((item) => item.active)
            .toList(growable: false);
        if (activeItems.isEmpty) {
          throw const StocktakeRepositoryFailure(
            'لا توجد أصناف نشطة لبدء جلسة الجرد.',
          );
        }

        final nextNumber =
            _readCounterValue(counterSnapshot, label: 'جلسات الجرد') + 1;
        final stocktakeNumber =
            'STK-${draft.periodTo.year}-${nextNumber.toString().padLeft(6, '0')}';

        _writeCounter(
          transaction: transaction,
          reference: counterReference,
          exists: counterSnapshot.exists,
          value: nextNumber,
          userId: user.uid,
        );
        transaction.set(stocktakeReference, {
          'stocktakeNumber': stocktakeNumber,
          'status': 'open',
          'periodFrom': Timestamp.fromDate(draft.periodFrom),
          'periodTo': Timestamp.fromDate(draft.periodTo),
          'startedAt': FieldValue.serverTimestamp(),
          'completedAt': null,
          'completedBy': '',
          'completionMovementId': '',
          'notes': draft.notes,
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': user.uid,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': user.uid,
        });

        for (final item in activeItems) {
          transaction.set(
            stocktakeReference
                .collection(FirestoreCollections.stocktakeLines)
                .doc(item.id),
            {
              'itemId': item.id,
              'itemNameSnapshot': item.name,
              'itemCodeSnapshot': item.code,
              'unit': item.unit,
              'itemsPerCarton': item.itemsPerCarton,
              'systemQuantityPieces': item.currentStockPieces,
              'actualQuantityPieces': 0,
              'differencePieces': -item.currentStockPieces,
              'counted': false,
              'countedAt': null,
              'countedBy': '',
            },
          );
        }

        return StocktakeSession(
          id: stocktakeReference.id,
          stocktakeNumber: stocktakeNumber,
          status: StocktakeStatus.open,
          periodFrom: draft.periodFrom,
          periodTo: draft.periodTo,
          startedAt: DateTime.now(),
          completedAt: null,
          notes: draft.notes,
        );
      });
    } on StocktakeRepositoryFailure {
      rethrow;
    } on FormatException {
      throw const StocktakeRepositoryFailure(
        'بيانات أحد الأصناف غير صالحة. حدّث الصفحة وحاول مرة أخرى.',
      );
    } on FirebaseException catch (error) {
      throw StocktakeRepositoryFailure(_writeFailureMessage(error));
    }
  }

  @override
  Future<void> saveCount({
    required String stocktakeId,
    required String itemId,
    required int actualQuantityPieces,
  }) async {
    final user = _requireUser();
    final stocktakeReference = _stocktakes.doc(stocktakeId);
    final lineReference = stocktakeReference
        .collection(FirestoreCollections.stocktakeLines)
        .doc(itemId);

    try {
      await _firestore.runTransaction((transaction) async {
        final stocktakeSnapshot = await transaction.get(stocktakeReference);
        final lineSnapshot = await transaction.get(lineReference);
        if (!stocktakeSnapshot.exists ||
            stocktakeSnapshot.data()?['status'] != 'open') {
          throw const StocktakeRepositoryFailure('جلسة الجرد لم تعد مفتوحة.');
        }
        if (!lineSnapshot.exists) {
          throw const StocktakeRepositoryFailure(
            'الصنف غير موجود داخل جلسة الجرد.',
          );
        }

        final systemQuantity = lineSnapshot.data()?['systemQuantityPieces'];
        if (systemQuantity is! int || systemQuantity < 0) {
          throw const StocktakeRepositoryFailure(
            'رصيد النظام المحفوظ للصنف غير صالح.',
          );
        }

        transaction.update(lineReference, {
          'actualQuantityPieces': actualQuantityPieces,
          'differencePieces': actualQuantityPieces - systemQuantity,
          'counted': true,
          'countedAt': FieldValue.serverTimestamp(),
          'countedBy': user.uid,
        });
      });
    } on StocktakeRepositoryFailure {
      rethrow;
    } on FirebaseException catch (error) {
      throw StocktakeRepositoryFailure(_writeFailureMessage(error));
    }
  }

  @override
  Future<SavedStocktakeCompletion> completeStocktake(String stocktakeId) async {
    final user = _requireUser();
    final stocktakeReference = _stocktakes.doc(stocktakeId);
    final lineQuerySnapshot = await stocktakeReference
        .collection(FirestoreCollections.stocktakeLines)
        .get();
    if (lineQuerySnapshot.docs.isEmpty) {
      throw const StocktakeRepositoryFailure('جلسة الجرد لا تحتوي على أصناف.');
    }

    final movementReference = _movements.doc();
    final adjustmentCounterReference = _counters.doc(_adjustmentCounterId);

    try {
      return await _firestore.runTransaction((transaction) async {
        final stocktakeSnapshot = await transaction.get(stocktakeReference);
        final lineSnapshots = <DocumentSnapshot<Map<String, dynamic>>>[];
        for (final lineDocument in lineQuerySnapshot.docs) {
          lineSnapshots.add(await transaction.get(lineDocument.reference));
        }

        if (!stocktakeSnapshot.exists ||
            stocktakeSnapshot.data()?['status'] != 'open') {
          throw const StocktakeRepositoryFailure(
            'تم اعتماد جلسة الجرد من قبل.',
          );
        }

        final session = _mapSession(
          id: stocktakeSnapshot.id,
          data: stocktakeSnapshot.data()!,
        );
        final lines = lineSnapshots
            .map(
              (snapshot) =>
                  _mapLine(itemId: snapshot.id, data: snapshot.data()!),
            )
            .toList(growable: false);
        if (lines.any((line) => !line.counted)) {
          throw const StocktakeRepositoryFailure(
            'يجب حفظ العدد الفعلي لكل الأصناف قبل اعتماد الجرد.',
          );
        }

        final adjustedLines = lines
            .where((line) => line.differencePieces != 0)
            .toList(growable: false);
        if (adjustedLines.length > _maximumAdjustmentItems) {
          throw const StocktakeRepositoryFailure(
            'عدد الأصناف ذات الفروق أكبر من 50. راجع الجرد قبل الاعتماد.',
          );
        }

        DocumentSnapshot<Map<String, dynamic>>? adjustmentCounterSnapshot;
        if (adjustedLines.isNotEmpty) {
          adjustmentCounterSnapshot = await transaction.get(
            adjustmentCounterReference,
          );
        }

        final itemSnapshots =
            <String, DocumentSnapshot<Map<String, dynamic>>>{};
        for (final line in adjustedLines) {
          itemSnapshots[line.itemId] = await transaction.get(
            _items.doc(line.itemId),
          );
        }

        String? movementVoucherNumber;
        if (adjustedLines.isNotEmpty) {
          final counterSnapshot = adjustmentCounterSnapshot!;
          final nextNumber =
              _readCounterValue(counterSnapshot, label: 'حركات تسوية الجرد') +
              1;
          movementVoucherNumber =
              'ADJ-${session.periodTo.year}-${nextNumber.toString().padLeft(6, '0')}';
          _writeCounter(
            transaction: transaction,
            reference: adjustmentCounterReference,
            exists: counterSnapshot.exists,
            value: nextNumber,
            userId: user.uid,
          );

          final itemIds = <String>[];
          final itemDeltas = <String, int>{};
          final movementLines = <Map<String, Object>>[];
          for (final line in adjustedLines) {
            final itemSnapshot = itemSnapshots[line.itemId];
            if (itemSnapshot == null || !itemSnapshot.exists) {
              throw StocktakeRepositoryFailure(
                'الصنف ${line.itemNameSnapshot} لم يعد موجودًا.',
              );
            }
            final item = InventoryItem.fromMap(
              id: itemSnapshot.id,
              data: itemSnapshot.data()!,
            );
            final adjustedStock =
                item.currentStockPieces + line.differencePieces;
            if (adjustedStock < 0) {
              throw StocktakeRepositoryFailure(
                'تعذر اعتماد ${line.itemNameSnapshot}: '
                'الرصيد الحالي لا يسمح بتطبيق فرق الجرد.',
              );
            }

            final absoluteDifference = line.differencePieces.abs();
            itemIds.add(item.id);
            itemDeltas[item.id] = line.differencePieces;
            movementLines.add({
              'itemId': item.id,
              'itemCode': line.itemCodeSnapshot,
              'itemName': line.itemNameSnapshot,
              'unit': line.unit,
              'itemsPerCarton': line.itemsPerCarton,
              'cartons': absoluteDifference ~/ line.itemsPerCarton,
              'pieces': absoluteDifference % line.itemsPerCarton,
              'totalPieces': absoluteDifference,
            });

            transaction.update(itemSnapshot.reference, {
              'currentStockPieces': adjustedStock,
              'totalAdjustmentPieces':
                  item.totalAdjustmentPieces + line.differencePieces,
              'lastMovementId': movementReference.id,
              'updatedAt': FieldValue.serverTimestamp(),
              'updatedBy': user.uid,
            });
          }

          transaction.set(movementReference, {
            'voucherNumber': movementVoucherNumber,
            'type': 'stocktakeAdjustment',
            'status': 'completed',
            'businessAt': FieldValue.serverTimestamp(),
            'partyName': 'جلسة الجرد ${session.stocktakeNumber}',
            'deliveredBy': '',
            'receivedBy': '',
            'driverName': '',
            'notes': session.notes,
            'itemIds': itemIds,
            'itemDeltas': itemDeltas,
            'lines': movementLines,
            'returnId': '',
            'stocktakeId': stocktakeId,
            'createdAt': FieldValue.serverTimestamp(),
            'createdBy': user.uid,
          });
        }

        transaction.update(stocktakeReference, {
          'status': 'completed',
          'completedAt': FieldValue.serverTimestamp(),
          'completedBy': user.uid,
          'completionMovementId': adjustedLines.isEmpty
              ? ''
              : movementReference.id,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': user.uid,
        });

        return SavedStocktakeCompletion(
          stocktakeNumber: session.stocktakeNumber,
          movementVoucherNumber: movementVoucherNumber,
          adjustedItemCount: adjustedLines.length,
          netDifferencePieces: adjustedLines.fold(
            0,
            (total, line) => total + line.differencePieces,
          ),
        );
      });
    } on StocktakeRepositoryFailure {
      rethrow;
    } on FormatException {
      throw const StocktakeRepositoryFailure(
        'بيانات جلسة الجرد غير صالحة. أعد تحميل الصفحة.',
      );
    } on FirebaseException catch (error) {
      throw StocktakeRepositoryFailure(_writeFailureMessage(error));
    }
  }

  User _requireUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const StocktakeRepositoryFailure(
        'انتهت جلسة الدخول. سجّل الدخول مرة أخرى.',
      );
    }
    return user;
  }

  int _readCounterValue(
    DocumentSnapshot<Map<String, dynamic>> snapshot, {
    required String label,
  }) {
    if (!snapshot.exists) {
      return 0;
    }
    final value = snapshot.data()?['value'];
    if (value is! int || value < 1) {
      throw StocktakeRepositoryFailure(
        'عداد $label غير صالح. راجع مسؤول النظام.',
      );
    }
    return value;
  }

  void _writeCounter({
    required Transaction transaction,
    required DocumentReference<Map<String, dynamic>> reference,
    required bool exists,
    required int value,
    required String userId,
  }) {
    final data = <String, Object>{
      'value': value,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': userId,
    };
    if (exists) {
      transaction.update(reference, data);
    } else {
      transaction.set(reference, data);
    }
  }

  StocktakeSession _mapSession({
    required String id,
    required Map<String, dynamic> data,
  }) {
    final stocktakeNumber = data['stocktakeNumber'];
    final status = data['status'];
    final periodFrom = data['periodFrom'];
    final periodTo = data['periodTo'];
    final startedAt = data['startedAt'];
    final completedAt = data['completedAt'];
    final notes = data['notes'];
    if (stocktakeNumber is! String ||
        status is! String ||
        periodFrom is! Timestamp ||
        periodTo is! Timestamp ||
        startedAt is! Timestamp ||
        completedAt is! Timestamp? ||
        notes is! String) {
      throw const FormatException('Malformed stocktake session.');
    }

    return StocktakeSession(
      id: id,
      stocktakeNumber: stocktakeNumber,
      status: StocktakeStatus.values.byName(status),
      periodFrom: periodFrom.toDate(),
      periodTo: periodTo.toDate(),
      startedAt: startedAt.toDate(),
      completedAt: completedAt?.toDate(),
      notes: notes,
    );
  }

  StocktakeLine _mapLine({
    required String itemId,
    required Map<String, dynamic> data,
  }) {
    final storedItemId = data['itemId'];
    final itemName = data['itemNameSnapshot'];
    final itemCode = data['itemCodeSnapshot'];
    final unit = data['unit'];
    final itemsPerCarton = data['itemsPerCarton'];
    final systemQuantity = data['systemQuantityPieces'];
    final actualQuantity = data['actualQuantityPieces'];
    final difference = data['differencePieces'];
    final counted = data['counted'];
    final countedAt = data['countedAt'];
    if (storedItemId != itemId ||
        itemName is! String ||
        itemCode is! String ||
        unit is! String ||
        itemsPerCarton is! int ||
        systemQuantity is! int ||
        actualQuantity is! int ||
        difference is! int ||
        counted is! bool ||
        countedAt is! Timestamp?) {
      throw const FormatException('Malformed stocktake line.');
    }

    return StocktakeLine(
      itemId: itemId,
      itemNameSnapshot: itemName,
      itemCodeSnapshot: itemCode,
      unit: unit,
      itemsPerCarton: itemsPerCarton,
      systemQuantityPieces: systemQuantity,
      actualQuantityPieces: actualQuantity,
      differencePieces: difference,
      counted: counted,
      countedAt: countedAt?.toDate(),
    );
  }

  String _readFailureMessage(FirebaseException error) {
    return switch (error.code) {
      'permission-denied' =>
        'لا توجد صلاحية لعرض جلسة الجرد. سجّل الدخول مرة أخرى.',
      'unavailable' => 'تعذر تحميل جلسة الجرد. تحقق من الإنترنت.',
      _ => 'تعذر تحميل جلسة الجرد الآن.',
    };
  }

  String _writeFailureMessage(FirebaseException error) {
    return switch (error.code) {
      'permission-denied' =>
        'تعذر حفظ جلسة الجرد بسبب الصلاحيات. سجّل الدخول مرة أخرى.',
      'unavailable' => 'تعذر حفظ جلسة الجرد. تحقق من الإنترنت.',
      'aborted' => 'تغير الرصيد أثناء الحفظ. أعد المحاولة.',
      _ => 'تعذر حفظ جلسة الجرد الآن.',
    };
  }
}
