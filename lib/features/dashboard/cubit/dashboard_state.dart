import '../data/models/item_model.dart';
import '../data/models/stock_summary_model.dart';

sealed class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final StockSummaryModel summary;
  final List<ItemModel> items;

  DashboardSuccess({
    required this.summary,
    required this.items,
  });
}

class DashboardFailure extends DashboardState {
  final String message;

  DashboardFailure(this.message);
}
