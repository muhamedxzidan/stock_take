import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/models/inventory_item.dart';
import '../models/return_resolution.dart';
import '../models/warehouse_return_draft.dart';
import '../models/warehouse_return_record.dart';
import 'returns_repository_base.dart';
import 'returns_repository_failure.dart';

class ReturnsRepository implements ReturnsRepositoryBase {
  static const String _customerReturnCounterId = 'customerReturn';
  static const String _returnResolutionCounterId = 'returnResolution';

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  ReturnsRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  }) : _firestore = firestore,
       _firebaseAuth = firebaseAuth;

  CollectionReference<Map<String, dynamic>> get _items =>
      _firestore.collection(FirestoreCollections.items);

  CollectionReference<Map<String, dynamic>> get _movements =>
      _firestore.collection(FirestoreCollections.movements);

  CollectionReference<Map<String, dynamic>> get _returns =>
      _firestore.collection(FirestoreCollections.returns);

  CollectionReference<Map<String, dynamic>> get _counters =>
      _firestore.collection(FirestoreCollections.counters);

  @override
  Stream<List<WarehouseReturnRecord>> watchPendingReturns() async* {
    try {
      await for (final snapshot
          in _returns
              .where(
                'status',
                isEqualTo: WarehouseReturnStatus.pendingSupplierResolution.name,
              )
              .snapshots()) {
        final records =
            snapshot.docs
                .map((document) => _mapReturn(document.id, document.data()))
                .toList()
              ..sort(
                (first, second) =>
                    second.receivedAt.compareTo(first.receivedAt),
              );
        yield List.unmodifiable(records);
      }
    } on FirebaseException catch (error) {
      throw ReturnsRepositoryFailure(_readFailureMessage(error));
    } on FormatException {
      throw const ReturnsRepositoryFailure(
        'بيانات أحد المرتجعات غير صالحة. راجع مسؤول النظام.',
      );
    }
  }

  @override
  Future<SavedWarehouseReturn> createCustomerReturn(
    WarehouseReturnDraft draft,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const ReturnsRepositoryFailure(
        'انتهت جلسة الدخول. سجّل الدخول مرة أخرى.',
      );
    }

    final itemReference = _items.doc(draft.itemId);
    final movementReference = _movements.doc();
    final returnReference = _returns.doc();
    final counterReference = _counters.doc(_customerReturnCounterId);

    try {
      return await _firestore.runTransaction((transaction) async {
        final counterSnapshot = await transaction.get(counterReference);
        final itemSnapshot = await transaction.get(itemReference);
        if (!itemSnapshot.exists) {
          throw ReturnsRepositoryFailure(
            'الصنف ${draft.itemName} لم يعد موجودًا.',
          );
        }

        final item = InventoryItem.fromMap(
          id: itemSnapshot.id,
          data: itemSnapshot.data()!,
        );
        if (!item.active) {
          throw ReturnsRepositoryFailure(
            'الصنف ${item.name} غير نشط ولا يمكن إرجاعه.',
          );
        }

        final nextCounterValue = counterSnapshot.exists
            ? _readCounterValue(counterSnapshot) + 1
            : 1;
        final returnNumber =
            'RET-${draft.receivedAt.year}-${nextCounterValue.toString().padLeft(6, '0')}';

        final counterData = <String, Object>{
          'value': nextCounterValue,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': user.uid,
        };
        if (counterSnapshot.exists) {
          transaction.update(counterReference, counterData);
        } else {
          transaction.set(counterReference, counterData);
        }

        transaction.update(itemReference, {
          'currentStockPieces': item.currentStockPieces + draft.quantityPieces,
          'totalCustomerReturnPieces':
              item.totalCustomerReturnPieces + draft.quantityPieces,
          'lastMovementId': movementReference.id,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': user.uid,
        });

        transaction.set(movementReference, {
          'voucherNumber': returnNumber,
          'type': 'customerReturn',
          'status': 'completed',
          'businessAt': Timestamp.fromDate(draft.receivedAt),
          'partyName': draft.sourceName,
          'deliveredBy': draft.returnedBy,
          'receivedBy': draft.receivedBy,
          'driverName': '',
          'notes': draft.notes,
          'itemIds': [item.id],
          'itemDeltas': {item.id: draft.quantityPieces},
          'lines': [
            {
              'itemId': item.id,
              'itemCode': item.code,
              'itemName': item.name,
              'unit': item.unit,
              'itemsPerCarton': item.itemsPerCarton,
              'cartons': draft.quantityPieces ~/ item.itemsPerCarton,
              'pieces': draft.quantityPieces % item.itemsPerCarton,
              'totalPieces': draft.quantityPieces,
            },
          ],
          'returnId': returnReference.id,
          'stocktakeId': '',
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': user.uid,
        });

        transaction.set(returnReference, {
          'returnNumber': returnNumber,
          'originalVoucherNumber': draft.originalVoucherNumber,
          'itemId': item.id,
          'itemNameSnapshot': item.name,
          'itemCodeSnapshot': item.code,
          'quantityPieces': draft.quantityPieces,
          'sourceName': draft.sourceName,
          'returnedBy': draft.returnedBy,
          'receivedBy': draft.receivedBy,
          'reason': draft.reason,
          'notes': draft.notes,
          'condition': draft.condition.name,
          'status': 'pendingSupplierResolution',
          'supplierName': '',
          'receiptMovementId': movementReference.id,
          'resolutionMovementId': '',
          'receivedAt': Timestamp.fromDate(draft.receivedAt),
          'resolvedAt': null,
          'resolvedBy': '',
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': user.uid,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': user.uid,
        });

        return SavedWarehouseReturn(
          returnId: returnReference.id,
          returnNumber: returnNumber,
          itemCode: item.code,
          quantityPieces: draft.quantityPieces,
        );
      });
    } on ReturnsRepositoryFailure {
      rethrow;
    } on FormatException {
      throw const ReturnsRepositoryFailure(
        'بيانات الصنف غير صالحة. حدّث الصفحة وحاول مرة أخرى.',
      );
    } on FirebaseException catch (error) {
      throw ReturnsRepositoryFailure(_writeFailureMessage(error));
    }
  }

  @override
  Future<SavedReturnResolution> resolveReturn(
    ReturnResolutionDraft draft,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const ReturnsRepositoryFailure(
        'انتهت جلسة الدخول. سجّل الدخول مرة أخرى.',
      );
    }

    final returnReference = _returns.doc(draft.returnId);
    final movementReference = _movements.doc();
    final counterReference = _counters.doc(_returnResolutionCounterId);

    try {
      return await _firestore.runTransaction((transaction) async {
        final returnSnapshot = await transaction.get(returnReference);
        final counterSnapshot = await transaction.get(counterReference);
        if (!returnSnapshot.exists) {
          throw const ReturnsRepositoryFailure('المرتجع لم يعد موجودًا.');
        }

        final warehouseReturn = _mapReturn(
          returnSnapshot.id,
          returnSnapshot.data()!,
        );
        if (warehouseReturn.status !=
            WarehouseReturnStatus.pendingSupplierResolution) {
          throw const ReturnsRepositoryFailure('تمت تسوية هذا المرتجع من قبل.');
        }

        final itemReference = _items.doc(warehouseReturn.itemId);
        final itemSnapshot = await transaction.get(itemReference);
        if (!itemSnapshot.exists) {
          throw ReturnsRepositoryFailure(
            'الصنف ${warehouseReturn.itemName} لم يعد موجودًا.',
          );
        }
        final item = InventoryItem.fromMap(
          id: itemSnapshot.id,
          data: itemSnapshot.data()!,
        );

        if (draft.kind == ReturnResolutionKind.returnedToSupplier &&
            warehouseReturn.quantityPieces > item.currentStockPieces) {
          throw ReturnsRepositoryFailure(
            'لا يمكن إرجاع ${item.name} (${item.code}) للمورد: '
            'المتاح ${item.currentStockPieces} قطعة فقط.',
          );
        }

        final nextCounterValue = counterSnapshot.exists
            ? _readCounterValue(counterSnapshot) + 1
            : 1;
        final resolutionNumber =
            'RS-${DateTime.now().year}-${nextCounterValue.toString().padLeft(6, '0')}';

        final counterData = <String, Object>{
          'value': nextCounterValue,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': user.uid,
        };
        if (counterSnapshot.exists) {
          transaction.update(counterReference, counterData);
        } else {
          transaction.set(counterReference, counterData);
        }

        final returnsToSupplier =
            draft.kind == ReturnResolutionKind.returnedToSupplier;
        final stockDelta = returnsToSupplier
            ? -warehouseReturn.quantityPieces
            : 0;
        if (returnsToSupplier) {
          transaction.update(itemReference, {
            'currentStockPieces':
                item.currentStockPieces - warehouseReturn.quantityPieces,
            'totalSupplierReturnPieces':
                item.totalSupplierReturnPieces + warehouseReturn.quantityPieces,
            'lastMovementId': movementReference.id,
            'updatedAt': FieldValue.serverTimestamp(),
            'updatedBy': user.uid,
          });
        }

        transaction.set(movementReference, {
          'voucherNumber': resolutionNumber,
          'type': returnsToSupplier ? 'supplierReturn' : 'supplierReplacement',
          'status': 'completed',
          'businessAt': FieldValue.serverTimestamp(),
          'partyName': draft.supplierName,
          'deliveredBy': warehouseReturn.receivedBy,
          'receivedBy': draft.supplierName,
          'driverName': '',
          'notes': warehouseReturn.notes,
          'itemIds': [item.id],
          'itemDeltas': {item.id: stockDelta},
          'lines': [
            {
              'itemId': item.id,
              'itemCode': item.code,
              'itemName': item.name,
              'unit': item.unit,
              'itemsPerCarton': item.itemsPerCarton,
              'cartons': warehouseReturn.quantityPieces ~/ item.itemsPerCarton,
              'pieces': warehouseReturn.quantityPieces % item.itemsPerCarton,
              'totalPieces': warehouseReturn.quantityPieces,
            },
          ],
          'returnId': warehouseReturn.id,
          'stocktakeId': '',
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': user.uid,
        });

        transaction.update(returnReference, {
          'status': draft.kind.name,
          'supplierName': draft.supplierName,
          'resolutionMovementId': movementReference.id,
          'resolvedAt': FieldValue.serverTimestamp(),
          'resolvedBy': user.uid,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': user.uid,
        });

        return SavedReturnResolution(
          returnId: warehouseReturn.id,
          returnNumber: warehouseReturn.returnNumber,
          movementId: movementReference.id,
          kind: draft.kind,
        );
      });
    } on ReturnsRepositoryFailure {
      rethrow;
    } on FormatException {
      throw const ReturnsRepositoryFailure(
        'بيانات المرتجع أو الصنف غير صالحة. حدّث الصفحة وحاول مرة أخرى.',
      );
    } on FirebaseException catch (error) {
      throw ReturnsRepositoryFailure(_writeFailureMessage(error));
    }
  }

  int _readCounterValue(
    DocumentSnapshot<Map<String, dynamic>> counterSnapshot,
  ) {
    final value = counterSnapshot.data()?['value'];
    if (value is! int || value < 1) {
      throw const ReturnsRepositoryFailure(
        'عداد المرتجعات غير صالح. راجع مسؤول النظام.',
      );
    }
    return value;
  }

  String _writeFailureMessage(FirebaseException error) {
    return switch (error.code) {
      'permission-denied' =>
        'تعذر حفظ المرتجع بسبب الصلاحيات. سجّل الدخول مرة أخرى.',
      'unavailable' => 'تعذر حفظ المرتجع. تحقق من الإنترنت.',
      'aborted' => 'تغير الرصيد أثناء الحفظ. حاول مرة أخرى.',
      _ => 'تعذر حفظ المرتجع الآن.',
    };
  }

  String _readFailureMessage(FirebaseException error) {
    return switch (error.code) {
      'permission-denied' =>
        'لا توجد صلاحية لعرض المرتجعات. سجّل الدخول مرة أخرى.',
      'unavailable' => 'تعذر تحميل المرتجعات. تحقق من الإنترنت.',
      _ => 'تعذر تحميل المرتجعات الآن.',
    };
  }

  WarehouseReturnRecord _mapReturn(String id, Map<String, dynamic> data) {
    final returnNumber = data['returnNumber'];
    final originalVoucherNumber = data['originalVoucherNumber'];
    final itemId = data['itemId'];
    final itemName = data['itemNameSnapshot'];
    final itemCode = data['itemCodeSnapshot'];
    final quantityPieces = data['quantityPieces'];
    final sourceName = data['sourceName'];
    final returnedBy = data['returnedBy'];
    final receivedBy = data['receivedBy'];
    final reason = data['reason'];
    final notes = data['notes'];
    final condition = data['condition'];
    final status = data['status'];
    final receivedAt = data['receivedAt'];

    if (returnNumber is! String ||
        originalVoucherNumber is! String ||
        itemId is! String ||
        itemName is! String ||
        itemCode is! String ||
        quantityPieces is! int ||
        sourceName is! String ||
        returnedBy is! String ||
        receivedBy is! String ||
        reason is! String ||
        notes is! String ||
        condition is! String ||
        status is! String ||
        receivedAt is! Timestamp) {
      throw const FormatException('Malformed warehouse return data.');
    }

    return WarehouseReturnRecord(
      id: id,
      returnNumber: returnNumber,
      originalVoucherNumber: originalVoucherNumber,
      itemId: itemId,
      itemName: itemName,
      itemCode: itemCode,
      quantityPieces: quantityPieces,
      sourceName: sourceName,
      returnedBy: returnedBy,
      receivedBy: receivedBy,
      reason: reason,
      notes: notes,
      condition: ReturnItemCondition.values.byName(condition),
      status: WarehouseReturnStatus.values.byName(status),
      receivedAt: receivedAt.toDate(),
    );
  }
}
