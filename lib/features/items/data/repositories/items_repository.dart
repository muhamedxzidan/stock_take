import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/models/inventory_item.dart';
import '../models/new_inventory_item_draft.dart';
import 'items_repository_failure.dart';
import 'items_repository_base.dart';

class ItemsRepository implements ItemsRepositoryBase {
  static const String _itemCounterId = 'itemCode';
  static const String _itemCodePrefix = 'S-N-';

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  ItemsRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  }) : _firestore = firestore,
       _firebaseAuth = firebaseAuth;

  CollectionReference<Map<String, dynamic>> get _items =>
      _firestore.collection(FirestoreCollections.items);

  CollectionReference<Map<String, dynamic>> get _counters =>
      _firestore.collection(FirestoreCollections.counters);

  @override
  Stream<List<InventoryItem>> watchActiveItems() async* {
    try {
      await for (final snapshot
          in _items
              .where('active', isEqualTo: true)
              .orderBy('name')
              .snapshots()) {
        yield snapshot.docs
            .map(
              (document) =>
                  InventoryItem.fromMap(id: document.id, data: document.data()),
            )
            .toList(growable: false);
      }
    } on FirebaseException catch (error) {
      throw ItemsRepositoryFailure(_readFailureMessage(error));
    } on FormatException {
      throw const ItemsRepositoryFailure(
        'بيانات أحد الأصناف غير صالحة. راجع مسؤول النظام.',
      );
    }
  }

  @override
  Future<InventoryItem> addItem(NewInventoryItemDraft draft) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const ItemsRepositoryFailure(
        'انتهت جلسة الدخول. سجّل الدخول مرة أخرى.',
      );
    }

    final counterReference = _counters.doc(_itemCounterId);

    try {
      return await _firestore.runTransaction((transaction) async {
        final counterSnapshot = await transaction.get(counterReference);
        final currentCounter = counterSnapshot.data()?['value'];
        if (counterSnapshot.exists && currentCounter is! int) {
          throw const ItemsRepositoryFailure(
            'عداد أكواد الأصناف غير صالح. راجع مسؤول النظام.',
          );
        }

        final nextNumber = (currentCounter as int? ?? 0) + 1;
        final itemCode = '$_itemCodePrefix$nextNumber';
        final itemReference = _items.doc(itemCode);
        final existingItem = await transaction.get(itemReference);
        if (existingItem.exists) {
          throw const ItemsRepositoryFailure(
            'تعذر إنشاء كود صنف جديد. راجع عداد الأصناف.',
          );
        }

        final item = InventoryItem(
          id: itemCode,
          code: itemCode,
          name: draft.name,
          unit: 'piece',
          itemsPerCarton: draft.itemsPerCarton,
          openingStockPieces: draft.openingStockPieces,
          currentStockPieces: draft.openingStockPieces,
          totalInboundPieces: 0,
          totalOutboundPieces: 0,
          totalCustomerReturnPieces: 0,
          totalSupplierReturnPieces: 0,
          totalAdjustmentPieces: 0,
          active: true,
        );

        final counterData = <String, Object>{
          'value': nextNumber,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': user.uid,
        };
        if (counterSnapshot.exists) {
          transaction.update(counterReference, counterData);
        } else {
          transaction.set(counterReference, counterData);
        }

        transaction.set(itemReference, {
          ...item.toCreateMap(),
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': user.uid,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': user.uid,
        });
        return item;
      });
    } on ItemsRepositoryFailure {
      rethrow;
    } on FirebaseException catch (error) {
      throw ItemsRepositoryFailure(_writeFailureMessage(error));
    }
  }

  String _readFailureMessage(FirebaseException error) {
    return switch (error.code) {
      'permission-denied' =>
        'لا توجد صلاحية لعرض الأصناف. سجّل الدخول مرة أخرى.',
      'unavailable' => 'تعذر تحميل الأصناف. تحقق من الإنترنت.',
      _ => 'تعذر تحميل الأصناف الآن.',
    };
  }

  String _writeFailureMessage(FirebaseException error) {
    return switch (error.code) {
      'permission-denied' =>
        'تعذر حفظ الصنف بسبب الصلاحيات. سجّل الدخول مرة أخرى.',
      'unavailable' => 'تعذر حفظ الصنف. تحقق من الإنترنت.',
      'aborted' => 'تغيرت البيانات أثناء الحفظ. حاول مرة أخرى.',
      _ => 'تعذر حفظ الصنف الآن.',
    };
  }
}
