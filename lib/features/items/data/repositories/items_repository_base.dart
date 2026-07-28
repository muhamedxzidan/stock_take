import '../../../../core/models/inventory_item.dart';
import '../models/new_inventory_item_draft.dart';

abstract class ItemsRepositoryBase {
  Stream<List<InventoryItem>> watchActiveItems();

  Future<InventoryItem> addItem(NewInventoryItemDraft draft);
}
