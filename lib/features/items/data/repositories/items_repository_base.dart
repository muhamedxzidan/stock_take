import '../../../dashboard/data/models/item_model.dart';

abstract class ItemsRepositoryBase {
  /// Registers a new item into inventory definitions.
  Future<void> addItem(ItemModel item);
}
