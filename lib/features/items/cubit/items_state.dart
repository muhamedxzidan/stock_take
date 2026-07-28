import '../../../core/models/inventory_item.dart';

sealed class ItemsState {}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsSuccess extends ItemsState {
  final InventoryItem item;

  ItemsSuccess(this.item);
}

class ItemsFailure extends ItemsState {
  final String message;

  ItemsFailure(this.message);
}
