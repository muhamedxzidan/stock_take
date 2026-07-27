import '../models/item_model.dart';
import '../models/stock_summary_model.dart';

/// Abstract interface contract for Dashboard data operations.
abstract class DashboardRepositoryBase {
  /// Fetches the stock summary totals.
  Future<StockSummaryModel> fetchStockSummary();

  /// Fetches the list of all inventory items.
  Future<List<ItemModel>> fetchItems();
}
