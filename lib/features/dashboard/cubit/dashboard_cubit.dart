import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/item_model.dart';
import '../data/repositories/dashboard_repository_base.dart';
import 'dashboard_state.dart';

/// DashboardCubit manages stock summary totals and stock items state.
class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepositoryBase _repository;
  Timer? _debounceTimer;
  List<ItemModel> _allItems = [];

  DashboardCubit(this._repository) : super(DashboardInitial());

  /// Loads initial stock summary and items list from repository.
  Future<void> loadDashboardData() async {
    emit(DashboardLoading());
    try {
      final summary = await _repository.fetchStockSummary();
      _allItems = await _repository.fetchItems();
      emit(DashboardSuccess(summary: summary, items: _allItems));
    } catch (e) {
      emit(DashboardFailure('فشل في تحميل بيانات المخزن. يرجى المحاولة لاحقاً.'));
    }
  }

  /// Filters items list based on user search query with 300ms debounce.
  void onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (state is DashboardSuccess) {
        final currentSuccessState = state as DashboardSuccess;
        final trimmed = query.trim().toLowerCase();
        if (trimmed.isEmpty) {
          emit(DashboardSuccess(
            summary: currentSuccessState.summary,
            items: _allItems,
          ));
        } else {
          final filtered = _allItems.where((item) {
            return item.name.toLowerCase().contains(trimmed) ||
                item.code.toLowerCase().contains(trimmed);
          }).toList();
          emit(DashboardSuccess(
            summary: currentSuccessState.summary,
            items: filtered,
          ));
        }
      }
    });
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
