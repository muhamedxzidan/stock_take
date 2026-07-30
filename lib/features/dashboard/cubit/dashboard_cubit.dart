import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/inventory_item.dart';
import '../data/models/stock_summary_model.dart';
import '../data/repositories/dashboard_repository_base.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepositoryBase _repository;
  Timer? _debounceTimer;
  StreamSubscription<List<InventoryItem>>? _itemsSubscription;
  List<InventoryItem> _allItems = [];
  String _searchQuery = '';

  DashboardCubit(this._repository) : super(DashboardInitial());

  Future<void> loadDashboardData() async {
    if (_itemsSubscription != null) {
      return;
    }

    emit(DashboardLoading());
    _itemsSubscription = _repository.watchItems().listen(
      (items) {
        _allItems = items;
        _emitFilteredItems();
      },
      onError: (_) {
        _itemsSubscription?.cancel();
        _itemsSubscription = null;
        emit(
          DashboardFailure(
            'فشل في تحميل بيانات المخزن. تحقق من الاتصال وحاول مرة أخرى.',
          ),
        );
      },
    );
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: 300),
      _emitFilteredItems,
    );
  }

  void _emitFilteredItems() {
    final normalizedQuery = _searchQuery.trim().toLowerCase();
    final visibleItems = normalizedQuery.isEmpty
        ? _allItems
        : _allItems
              .where((item) => item.matchesSearch(normalizedQuery))
              .toList(growable: false);

    emit(
      DashboardSuccess(
        summary: _buildSummary(_allItems),
        items: List.unmodifiable(visibleItems),
        allItems: List.unmodifiable(_allItems),
      ),
    );
  }

  StockSummaryModel _buildSummary(List<InventoryItem> items) {
    return StockSummaryModel(
      totalItemsCount: items.length,
      totalInboundCount: items.fold(
        0,
        (sum, item) => sum + item.totalInboundPieces,
      ),
      totalOutboundCount: items.fold(
        0,
        (sum, item) => sum + item.totalOutboundPieces,
      ),
      lowStockItemsCount: items
          .where((item) => item.currentStockPieces <= 30)
          .length,
    );
  }

  @override
  Future<void> close() async {
    _debounceTimer?.cancel();
    await _itemsSubscription?.cancel();
    return super.close();
  }
}
