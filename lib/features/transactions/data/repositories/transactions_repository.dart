import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/models/inventory_item.dart';
import '../models/inventory_movement.dart';
import '../models/movement_record.dart';
import '../models/transaction_model.dart';
import 'transactions_repository_failure.dart';
import 'transactions_repository_base.dart';

enum _InventoryMovementWriteKind {
  inbound(
    firestoreType: 'inbound',
    counterId: 'inboundVoucher',
    voucherPrefix: 'IN',
    arabicLabel: 'الوارد',
  ),
  outbound(
    firestoreType: 'outbound',
    counterId: 'outboundVoucher',
    voucherPrefix: 'OUT',
    arabicLabel: 'المنصرف',
  );

  final String firestoreType;
  final String counterId;
  final String voucherPrefix;
  final String arabicLabel;

  const _InventoryMovementWriteKind({
    required this.firestoreType,
    required this.counterId,
    required this.voucherPrefix,
    required this.arabicLabel,
  });

  int stockDelta(int quantity) => this == inbound ? quantity : -quantity;
}

class TransactionsRepository implements TransactionsRepositoryBase {
  static const _inventoryControlId = 'primaryWarehouse';

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  TransactionsRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  }) : _firestore = firestore,
       _firebaseAuth = firebaseAuth;

  final List<TransactionModel> _logs = [
    const TransactionModel(
      id: '101',
      voucherNumber: 'INV-2026-001',
      type: TransactionType.inbound,
      itemId: '1',
      itemName: 'شامبو لوريال 400 مل',
      itemCode: 'ITM-001',
      quantity: 50,
      unit: 'قطعة',
      partyName: 'شركة النيل للتوريدات',
      actorName: 'أحمد محمود (مندوب المورد)',
      receiverName: 'محمد زيدان (أمين المخزن)',
      date: '2026-07-24 10:30 ص',
      notes: 'توريد دفعة شهر يوليو',
    ),
    const TransactionModel(
      id: '102',
      voucherNumber: 'OUT-2026-001',
      type: TransactionType.outbound,
      itemId: '2',
      itemName: 'صابون دوف زهر 100جم',
      itemCode: 'ITM-002',
      quantity: 30,
      unit: 'قطعة',
      partyName: 'فرع الجيزة الرئيسي',
      actorName: 'محمد زيدان (أمين المخزن)',
      receiverName: 'محمود حسن (سائق النقل)',
      date: '2026-07-24 02:15 م',
      notes: 'صرف بضاعة لفرع الجيزة',
    ),
    const TransactionModel(
      id: '103',
      voucherNumber: 'ADJ-2026-001',
      type: TransactionType.adjustment,
      itemId: '3',
      itemName: 'معجون أسنان سنسوداين 75مل',
      itemCode: 'ITM-003',
      quantity: -5,
      unit: 'قطعة',
      partyName: 'تعديل جرد دوري',
      actorName: 'محمد زيدان',
      receiverName: 'محمد زيدان',
      date: '2026-07-25 09:00 ص',
      notes: 'عجز جردي نتيجة تالف بضاعة',
    ),
  ];

  CollectionReference<Map<String, dynamic>> get _items =>
      _firestore.collection(FirestoreCollections.items);

  CollectionReference<Map<String, dynamic>> get _movements =>
      _firestore.collection(FirestoreCollections.movements);

  CollectionReference<Map<String, dynamic>> get _counters =>
      _firestore.collection(FirestoreCollections.counters);

  CollectionReference<Map<String, dynamic>> get _stocktakes =>
      _firestore.collection(FirestoreCollections.stocktakes);

  DocumentReference<Map<String, dynamic>> get _inventoryControl => _firestore
      .collection(FirestoreCollections.inventoryControl)
      .doc(_inventoryControlId);

  @override
  Stream<List<MovementRecord>> watchMovements() async* {
    try {
      await for (final snapshot
          in _movements.orderBy('businessAt', descending: true).snapshots()) {
        yield snapshot.docs
            .map(
              (document) =>
                  _mapMovementRecord(id: document.id, data: document.data()),
            )
            .toList(growable: false);
      }
    } on FirebaseException catch (error) {
      throw TransactionsRepositoryFailure(_historyReadFailureMessage(error));
    } on FormatException {
      throw const TransactionsRepositoryFailure(
        'بيانات إحدى الحركات غير صالحة. راجع مسؤول النظام.',
      );
    }
  }

  @override
  Future<SavedInventoryMovement> createInboundMovement(
    InventoryMovementDraft draft,
  ) {
    return _createInventoryMovement(
      draft: draft,
      kind: _InventoryMovementWriteKind.inbound,
    );
  }

  @override
  Future<SavedInventoryMovement> createOutboundMovement(
    InventoryMovementDraft draft,
  ) {
    return _createInventoryMovement(
      draft: draft,
      kind: _InventoryMovementWriteKind.outbound,
    );
  }

  Future<SavedInventoryMovement> _createInventoryMovement({
    required InventoryMovementDraft draft,
    required _InventoryMovementWriteKind kind,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const TransactionsRepositoryFailure(
        'انتهت جلسة الدخول. سجّل الدخول مرة أخرى.',
      );
    }

    final movementReference = _movements.doc();
    final counterReference = _counters.doc(kind.counterId);
    final lineByItemId = <String, InventoryMovementLine>{
      for (final line in draft.lines) line.itemId: line,
    };

    if (lineByItemId.length != draft.lines.length) {
      throw const TransactionsRepositoryFailure(
        'لا يمكن إضافة الصنف نفسه مرتين داخل الإذن.',
      );
    }

    try {
      await _ensureNoLegacyOpenStocktake();
      return await _firestore.runTransaction((transaction) async {
        final controlSnapshot = await transaction.get(_inventoryControl);
        _ensureInventoryIsUnlocked(controlSnapshot);
        final counterSnapshot = await transaction.get(counterReference);
        final itemSnapshots =
            <String, DocumentSnapshot<Map<String, dynamic>>>{};

        for (final line in draft.lines) {
          final itemReference = _items.doc(line.itemId);
          itemSnapshots[line.itemId] = await transaction.get(itemReference);
        }

        final nextCounterValue = counterSnapshot.exists
            ? _readCounterValue(counterSnapshot, kind: kind) + 1
            : 1;
        final voucherNumber =
            '${kind.voucherPrefix}-${draft.businessDate.year}-${nextCounterValue.toString().padLeft(6, '0')}';

        if (counterSnapshot.exists) {
          transaction.update(counterReference, {
            'value': nextCounterValue,
            'updatedAt': FieldValue.serverTimestamp(),
            'updatedBy': user.uid,
          });
        } else {
          transaction.set(counterReference, {
            'value': nextCounterValue,
            'updatedAt': FieldValue.serverTimestamp(),
            'updatedBy': user.uid,
          });
        }

        final itemIds = <String>[];
        final itemDeltas = <String, int>{};
        final lineSnapshots = <Map<String, Object>>[];

        for (final line in draft.lines) {
          final itemSnapshot = itemSnapshots[line.itemId];
          if (itemSnapshot == null || !itemSnapshot.exists) {
            throw TransactionsRepositoryFailure(
              'الصنف ${line.itemName} لم يعد موجودًا.',
            );
          }

          final item = InventoryItem.fromMap(
            id: itemSnapshot.id,
            data: itemSnapshot.data()!,
          );
          if (!item.active) {
            throw TransactionsRepositoryFailure(
              'الصنف ${item.name} غير نشط ولا يمكن استخدامه.',
            );
          }

          final quantity = (line.cartons * item.itemsPerCarton) + line.pieces;
          if (quantity <= 0) {
            throw TransactionsRepositoryFailure(
              'كمية الصنف ${item.name} غير صالحة.',
            );
          }
          if (kind == _InventoryMovementWriteKind.outbound &&
              quantity > item.currentStockPieces) {
            throw TransactionsRepositoryFailure(
              'لا يمكن صرف ${item.name} (${item.code}): '
              'المتاح ${item.currentStockPieces} قطعة فقط.',
            );
          }

          final stockDelta = kind.stockDelta(quantity);
          itemIds.add(item.id);
          itemDeltas[item.id] = stockDelta;
          lineSnapshots.add({
            'itemId': item.id,
            'itemCode': item.code,
            'itemName': item.name,
            'unit': item.unit,
            'itemsPerCarton': item.itemsPerCarton,
            'cartons': line.cartons,
            'pieces': line.pieces,
            'totalPieces': quantity,
          });

          transaction.update(itemSnapshot.reference, {
            'currentStockPieces': item.currentStockPieces + stockDelta,
            if (kind == _InventoryMovementWriteKind.inbound)
              'totalInboundPieces': item.totalInboundPieces + quantity
            else
              'totalOutboundPieces': item.totalOutboundPieces + quantity,
            'lastMovementId': movementReference.id,
            'updatedAt': FieldValue.serverTimestamp(),
            'updatedBy': user.uid,
          });
        }

        transaction.set(movementReference, {
          'voucherNumber': voucherNumber,
          'type': kind.firestoreType,
          'status': 'completed',
          'businessAt': Timestamp.fromDate(draft.businessDate),
          'partyName': draft.partyName,
          'deliveredBy': draft.deliveredBy,
          'receivedBy': draft.receivedBy,
          'driverName': draft.driverName,
          'notes': draft.notes,
          'itemIds': itemIds,
          'itemDeltas': itemDeltas,
          'lines': lineSnapshots,
          'returnId': '',
          'stocktakeId': '',
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': user.uid,
        });

        return SavedInventoryMovement(
          movementId: movementReference.id,
          voucherNumber: voucherNumber,
        );
      });
    } on TransactionsRepositoryFailure {
      rethrow;
    } on FormatException {
      throw const TransactionsRepositoryFailure(
        'بيانات أحد الأصناف غير صالحة. حدّث الصفحة وحاول مرة أخرى.',
      );
    } on FirebaseException catch (error) {
      throw TransactionsRepositoryFailure(
        _writeFailureMessage(error, kind: kind),
      );
    }
  }

  Future<void> _ensureNoLegacyOpenStocktake() async {
    final snapshot = await _stocktakes
        .where('status', isEqualTo: 'open')
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      throw const TransactionsRepositoryFailure(
        'لا يمكن تسجيل حركة مخزون أثناء وجود جلسة جرد مفتوحة.',
      );
    }
  }

  void _ensureInventoryIsUnlocked(
    DocumentSnapshot<Map<String, dynamic>> controlSnapshot,
  ) {
    final activeStocktakeId =
        controlSnapshot.data()?['activeStocktakeId'] as String?;
    if (activeStocktakeId != null && activeStocktakeId.isNotEmpty) {
      throw const TransactionsRepositoryFailure(
        'لا يمكن تسجيل حركة مخزون أثناء وجود جلسة جرد مفتوحة.',
      );
    }
  }

  int _readCounterValue(
    DocumentSnapshot<Map<String, dynamic>> counterSnapshot, {
    required _InventoryMovementWriteKind kind,
  }) {
    final value = counterSnapshot.data()?['value'];
    if (value is! int || value < 1) {
      throw TransactionsRepositoryFailure(
        'عداد أذون ${kind.arabicLabel} غير صالح. راجع مسؤول النظام.',
      );
    }
    return value;
  }

  String _writeFailureMessage(
    FirebaseException error, {
    required _InventoryMovementWriteKind kind,
  }) {
    return switch (error.code) {
      'permission-denied' =>
        'تعذر حفظ ${kind.arabicLabel} بسبب الصلاحيات. سجّل الدخول مرة أخرى.',
      'unavailable' => 'تعذر حفظ ${kind.arabicLabel}. تحقق من الإنترنت.',
      'aborted' => 'تغير الرصيد أثناء الحفظ. حاول مرة أخرى.',
      _ => 'تعذر حفظ إذن ${kind.arabicLabel} الآن.',
    };
  }

  String _historyReadFailureMessage(FirebaseException error) {
    return switch (error.code) {
      'permission-denied' =>
        'لا توجد صلاحية لعرض سجل الحركات. سجّل الدخول مرة أخرى.',
      'unavailable' => 'تعذر تحميل سجل الحركات. تحقق من الإنترنت.',
      _ => 'تعذر تحميل سجل الحركات الآن.',
    };
  }

  MovementRecord _mapMovementRecord({
    required String id,
    required Map<String, dynamic> data,
  }) {
    final voucherNumber = data['voucherNumber'];
    final type = data['type'];
    final businessAt = data['businessAt'];
    final partyName = data['partyName'];
    final deliveredBy = data['deliveredBy'];
    final receivedBy = data['receivedBy'];
    final driverName = data['driverName'];
    final notes = data['notes'];
    final rawLines = data['lines'];
    final rawItemDeltas = data['itemDeltas'];

    if (voucherNumber is! String ||
        type is! String ||
        businessAt is! Timestamp ||
        partyName is! String ||
        deliveredBy is! String ||
        receivedBy is! String ||
        driverName is! String ||
        notes is! String ||
        rawLines is! List ||
        rawItemDeltas is! Map) {
      throw const FormatException('Malformed movement data.');
    }

    final lines = rawLines
        .map((rawLine) {
          if (rawLine is! Map) {
            throw const FormatException('Malformed movement line.');
          }

          final line = Map<String, dynamic>.from(rawLine);
          final itemId = line['itemId'];
          final itemCode = line['itemCode'];
          final itemName = line['itemName'];
          final unit = line['unit'];
          final itemsPerCarton = line['itemsPerCarton'];
          final cartons = line['cartons'];
          final pieces = line['pieces'];
          final totalPieces = line['totalPieces'];
          if (itemId is! String ||
              itemCode is! String ||
              itemName is! String ||
              unit is! String ||
              itemsPerCarton is! int ||
              cartons is! int ||
              pieces is! int ||
              totalPieces is! int) {
            throw const FormatException('Malformed movement line.');
          }

          return MovementRecordLine(
            itemId: itemId,
            itemCode: itemCode,
            itemName: itemName,
            unit: unit,
            itemsPerCarton: itemsPerCarton,
            cartons: cartons,
            pieces: pieces,
            totalPieces: totalPieces,
          );
        })
        .toList(growable: false);

    final itemDeltas = <String, int>{};
    for (final entry in rawItemDeltas.entries) {
      if (entry.key is! String || entry.value is! int) {
        throw const FormatException('Malformed movement item deltas.');
      }
      itemDeltas[entry.key as String] = entry.value as int;
    }

    return MovementRecord(
      id: id,
      voucherNumber: voucherNumber,
      type: MovementRecordType.values.byName(type),
      businessAt: businessAt.toDate(),
      partyName: partyName,
      deliveredBy: deliveredBy,
      receivedBy: receivedBy,
      driverName: driverName,
      notes: notes,
      lines: lines,
      itemDeltas: Map.unmodifiable(itemDeltas),
    );
  }

  @override
  Future<void> createTransaction(TransactionModel transaction) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logs.insert(0, transaction);
  }

  @override
  Future<List<TransactionModel>> fetchTransactions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_logs);
  }
}
