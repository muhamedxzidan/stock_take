import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/inventory_item.dart';
import '../data/repositories/items_repository_base.dart';
import '../data/repositories/items_repository_failure.dart';
import 'items_state.dart';

/// ItemsCubit manages item definition submission and validation.
class ItemsCubit extends Cubit<ItemsState> {
  final ItemsRepositoryBase _repository;

  ItemsCubit(this._repository) : super(ItemsInitial());

  /// Validates inputs and saves new item model.
  Future<void> submitNewItem({
    required String name,
    required String code,
    required String itemsPerCartonStr,
    required String initialBalanceStr,
  }) async {
    if (state is ItemsLoading) {
      return;
    }

    final normalizedName = name.trim();
    final normalizedCode = code.trim().toUpperCase();
    if (normalizedName.isEmpty || normalizedName.length > 200) {
      emit(ItemsFailure('اكتب اسم صنف صحيحًا.'));
      return;
    }
    if (normalizedCode.length > 50 ||
        !RegExp(r'^[A-Z0-9_-]+$').hasMatch(normalizedCode)) {
      emit(ItemsFailure('كود الصنف يقبل حروفًا إنجليزية وأرقامًا وشرطة فقط.'));
      return;
    }

    final itemsPerCarton = int.tryParse(itemsPerCartonStr.trim());
    if (itemsPerCarton == null || itemsPerCarton <= 0) {
      emit(ItemsFailure('عدد القطع في الكرتونة يجب أن يكون أكبر من صفر.'));
      return;
    }

    final initialBalance = int.tryParse(initialBalanceStr.trim());
    if (initialBalance == null || initialBalance < 0) {
      emit(ItemsFailure('الرصيد الافتتاحي يجب أن يكون صفرًا أو أكبر.'));
      return;
    }

    emit(ItemsLoading());
    try {
      final newItem = InventoryItem(
        id: normalizedCode,
        code: normalizedCode,
        name: normalizedName,
        unit: 'piece',
        itemsPerCarton: itemsPerCarton,
        openingStockPieces: initialBalance,
        currentStockPieces: initialBalance,
        totalInboundPieces: 0,
        totalOutboundPieces: 0,
        totalCustomerReturnPieces: 0,
        totalSupplierReturnPieces: 0,
        totalAdjustmentPieces: 0,
        active: true,
      );

      await _repository.addItem(newItem);
      emit(ItemsSuccess());
    } on ItemsRepositoryFailure catch (failure) {
      emit(ItemsFailure(failure.message));
    } catch (_) {
      emit(ItemsFailure('تعذر حفظ الصنف الآن. حاول مرة أخرى.'));
    }
  }
}
