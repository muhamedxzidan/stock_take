import '../../../../core/models/inventory_item.dart';
import '../../../items/data/repositories/items_repository_base.dart';
import 'dashboard_repository_base.dart';

class DashboardRepository implements DashboardRepositoryBase {
  final ItemsRepositoryBase _itemsRepository;

  DashboardRepository(this._itemsRepository);

  @override
  Stream<List<InventoryItem>> watchItems() =>
      _itemsRepository.watchActiveItems();
}
