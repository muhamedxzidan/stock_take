import '../../../core/models/inventory_item.dart';

sealed class ItemCatalogState {
  const ItemCatalogState();
}

class ItemCatalogInitial extends ItemCatalogState {
  const ItemCatalogInitial();
}

class ItemCatalogLoading extends ItemCatalogState {
  const ItemCatalogLoading();
}

class ItemCatalogSuccess extends ItemCatalogState {
  final List<InventoryItem> items;

  const ItemCatalogSuccess(this.items);
}

class ItemCatalogFailure extends ItemCatalogState {
  final String message;

  const ItemCatalogFailure(this.message);
}
