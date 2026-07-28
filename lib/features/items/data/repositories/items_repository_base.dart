import '../../../../core/models/inventory_item.dart';

abstract class ItemsRepositoryBase {
  Stream<List<InventoryItem>> watchActiveItems();

  Future<void> addItem(InventoryItem item);
}
