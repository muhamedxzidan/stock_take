import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dashboard/data/models/item_model.dart';
import '../data/repositories/items_repository_base.dart';
import 'items_state.dart';

/// ItemsCubit manages item definition submission and validation.
class ItemsCubit extends Cubit<ItemsState> {
  final ItemsRepositoryBase _repository;

  ItemsCubit(this._repository) : super(ItemsInitial());

  /// Validates inputs and saves new item model.
  Future<void> submitNewItem({
    required String name,
    required String code,
    required String unit,
    required String itemsPerCartonStr,
    required String initialBalanceStr,
  }) async {
    if (name.trim().isEmpty || code.trim().isEmpty) {
      emit(ItemsFailure('يرجى ملء اسم الصنف والكود بشكل صحيح.'));
      return;
    }

    final itemsPerCarton = int.tryParse(itemsPerCartonStr) ?? 1;
    final initialBalance = int.tryParse(initialBalanceStr) ?? 0;

    emit(ItemsLoading());
    try {
      final newItem = ItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        code: code.trim(),
        name: name.trim(),
        unit: unit.isEmpty ? 'قطعة' : unit,
        itemsPerCarton: itemsPerCarton,
        openingBalance: initialBalance,
        totalInbound: 0,
        totalOutbound: 0,
      );

      await _repository.addItem(newItem);
      emit(ItemsSuccess());
    } catch (e) {
      emit(ItemsFailure('حدث خطأ أثناء حفظ الصنف. حاول مرة أخرى.'));
    }
  }
}
