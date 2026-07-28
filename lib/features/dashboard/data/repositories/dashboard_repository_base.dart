import '../../../../core/models/inventory_item.dart';

abstract class DashboardRepositoryBase {
  Stream<List<InventoryItem>> watchItems();
}
