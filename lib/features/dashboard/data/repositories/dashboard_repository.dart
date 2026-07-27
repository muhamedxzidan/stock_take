import '../models/item_model.dart';
import '../models/stock_summary_model.dart';
import 'dashboard_repository_base.dart';

/// Concrete implementation of [DashboardRepositoryBase] with initial mock data.
class DashboardRepository implements DashboardRepositoryBase {
  final List<ItemModel> _items = [
    const ItemModel(
      id: '1',
      code: 'ITM-001',
      name: 'شامبو لوريال 400 مل',
      unit: 'قطعة',
      itemsPerCarton: 12,
      openingBalance: 100,
      totalInbound: 50,
      totalOutbound: 20,
    ),
    const ItemModel(
      id: '2',
      code: 'ITM-002',
      name: 'صابون دوف زهر 100جم',
      unit: 'قطعة',
      itemsPerCarton: 24,
      openingBalance: 200,
      totalInbound: 100,
      totalOutbound: 280, // Low balance example
    ),
    const ItemModel(
      id: '3',
      code: 'ITM-003',
      name: 'معجون أسنان سنسوداين 75مل',
      unit: 'قطعة',
      itemsPerCarton: 10,
      openingBalance: 50,
      totalInbound: 80,
      totalOutbound: 30,
    ),
    const ItemModel(
      id: '4',
      code: 'ITM-004',
      name: 'مناديل فاين 500 سحبة',
      unit: 'علبة',
      itemsPerCarton: 36,
      openingBalance: 300,
      totalInbound: 150,
      totalOutbound: 100,
    ),
  ];

  @override
  Future<StockSummaryModel> fetchStockSummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowStock = _items.where((item) => item.currentStockBalance <= 30).length;
    final totalInbound = _items.fold(0, (sum, i) => sum + i.totalInbound);
    final totalOutbound = _items.fold(0, (sum, i) => sum + i.totalOutbound);

    return StockSummaryModel(
      totalItemsCount: _items.length,
      totalInboundCount: totalInbound,
      totalOutboundCount: totalOutbound,
      lowStockItemsCount: lowStock,
    );
  }

  @override
  Future<List<ItemModel>> fetchItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_items);
  }
}
