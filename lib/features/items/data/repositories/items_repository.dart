import '../../../dashboard/data/models/item_model.dart';
import 'items_repository_base.dart';

class ItemsRepository implements ItemsRepositoryBase {
  @override
  Future<void> addItem(ItemModel item) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
