import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/movement_record.dart';
import '../data/models/movement_report_summary.dart';
import '../data/repositories/transactions_repository_base.dart';
import '../data/repositories/transactions_repository_failure.dart';
import 'movement_history_state.dart';

class MovementHistoryCubit extends Cubit<MovementHistoryState> {
  final TransactionsRepositoryBase _repository;
  StreamSubscription<List<MovementRecord>>? _subscription;
  Timer? _searchDebounce;
  List<MovementRecord> _allMovements = const [];
  String _searchQuery = '';
  MovementRecordType? _selectedType;
  MovementDateFilterMode _dateFilterMode = MovementDateFilterMode.all;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  MovementHistoryCubit(this._repository) : super(MovementHistoryInitial());

  void loadMovements() {
    if (_subscription != null) {
      return;
    }

    emit(MovementHistoryLoading());
    _subscription = _repository.watchMovements().listen(
      (movements) {
        _allMovements = List.unmodifiable(movements);
        _emitFilteredMovements();
      },
      onError: (Object error) {
        _subscription?.cancel();
        _subscription = null;
        final message = error is TransactionsRepositoryFailure
            ? error.message
            : 'تعذر تحميل سجل الحركات الآن.';
        emit(MovementHistoryFailure(message));
      },
    );
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 300),
      _emitFilteredMovements,
    );
  }

  void filterByType(MovementRecordType? type) {
    _selectedType = type;
    _emitFilteredMovements();
  }

  void showAllDates() {
    _dateFilterMode = MovementDateFilterMode.all;
    _dateFrom = null;
    _dateTo = null;
    _emitFilteredMovements();
  }

  void showToday() {
    final now = DateTime.now();
    _dateFilterMode = MovementDateFilterMode.today;
    _dateFrom = DateTime(now.year, now.month, now.day);
    _dateTo = _dateFrom;
    _emitFilteredMovements();
  }

  void setDateRange({required DateTime from, required DateTime to}) {
    final normalizedFrom = DateTime(from.year, from.month, from.day);
    final normalizedTo = DateTime(to.year, to.month, to.day);
    if (normalizedFrom.isAfter(normalizedTo)) {
      emit(MovementHistoryFailure('تاريخ البداية يجب أن يسبق تاريخ النهاية.'));
      return;
    }

    _dateFilterMode = MovementDateFilterMode.range;
    _dateFrom = normalizedFrom;
    _dateTo = normalizedTo;
    _emitFilteredMovements();
  }

  void _emitFilteredMovements() {
    var visibleMovements = _allMovements
        .where((movement) {
          if (_selectedType != null && movement.type != _selectedType) {
            return false;
          }
          if (!movement.matchesSearch(_searchQuery)) {
            return false;
          }
          return _matchesDateFilter(movement.businessAt);
        })
        .toList(growable: false);

    visibleMovements = List.unmodifiable(visibleMovements);
    emit(
      MovementHistorySuccess(
        movements: visibleMovements,
        summary: MovementReportSummary.fromMovements(visibleMovements),
        selectedType: _selectedType,
        dateFilterMode: _dateFilterMode,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
      ),
    );
  }

  bool _matchesDateFilter(DateTime date) {
    if (_dateFilterMode == MovementDateFilterMode.all) {
      return true;
    }

    final movementDate = DateTime(date.year, date.month, date.day);
    final from = _dateFrom;
    final to = _dateTo;
    if (from == null || to == null) {
      return true;
    }
    return !movementDate.isBefore(from) && !movementDate.isAfter(to);
  }

  @override
  Future<void> close() async {
    _searchDebounce?.cancel();
    await _subscription?.cancel();
    return super.close();
  }
}
