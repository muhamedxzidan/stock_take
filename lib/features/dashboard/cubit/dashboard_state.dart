import '../../../core/models/inventory_item.dart';
import '../data/models/stock_summary_model.dart';

sealed class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final StockSummaryModel summary;
  final List<InventoryItem> items;
  final List<InventoryItem> allItems;

  DashboardSuccess({
    required this.summary,
    required this.items,
    required this.allItems,
  });
}

class DashboardFailure extends DashboardState {
  final String message;

  DashboardFailure(this.message);
}
