import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/models/inventory_item.dart';
import 'items_repository_failure.dart';
import 'items_repository_base.dart';

class ItemsRepository implements ItemsRepositoryBase {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  ItemsRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  }) : _firestore = firestore,
       _firebaseAuth = firebaseAuth;

  CollectionReference<Map<String, dynamic>> get _items =>
      _firestore.collection(FirestoreCollections.items);

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
  Future<void> addItem(InventoryItem item) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const ItemsRepositoryFailure(
        'انتهت جلسة الدخول. سجّل الدخول مرة أخرى.',
      );
    }

    final itemReference = _items.doc(item.id);

    try {
      await _firestore.runTransaction((transaction) async {
        final existingItem = await transaction.get(itemReference);
        if (existingItem.exists) {
          throw const ItemsRepositoryFailure('كود الصنف مستخدم بالفعل.');
        }

        transaction.set(itemReference, {
          ...item.toCreateMap(),
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': user.uid,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': user.uid,
        });
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
