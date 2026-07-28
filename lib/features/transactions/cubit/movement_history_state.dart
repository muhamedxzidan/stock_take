import '../data/models/movement_record.dart';
import '../data/models/movement_report_summary.dart';

enum MovementDateFilterMode { all, today, range }

sealed class MovementHistoryState {}

class MovementHistoryInitial extends MovementHistoryState {}

class MovementHistoryLoading extends MovementHistoryState {}

class MovementHistorySuccess extends MovementHistoryState {
  final List<MovementRecord> movements;
  final MovementReportSummary summary;
  final MovementRecordType? selectedType;
  final MovementDateFilterMode dateFilterMode;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  MovementHistorySuccess({
    required this.movements,
    required this.summary,
    required this.selectedType,
    required this.dateFilterMode,
    required this.dateFrom,
    required this.dateTo,
  });
}

class MovementHistoryFailure extends MovementHistoryState {
  final String message;

  MovementHistoryFailure(this.message);
}
