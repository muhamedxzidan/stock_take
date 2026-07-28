import '../data/models/return_resolution.dart';
import '../data/models/warehouse_return_record.dart';

sealed class ReturnResolutionState {
  final List<WarehouseReturnRecord> pendingReturns;

  const ReturnResolutionState(this.pendingReturns);
}

class ReturnResolutionInitial extends ReturnResolutionState {
  const ReturnResolutionInitial() : super(const []);
}

class ReturnResolutionLoading extends ReturnResolutionState {
  const ReturnResolutionLoading() : super(const []);
}

class ReturnResolutionReady extends ReturnResolutionState {
  const ReturnResolutionReady(super.pendingReturns);
}

class ReturnResolutionSaving extends ReturnResolutionState {
  final String returnId;

  const ReturnResolutionSaving(super.pendingReturns, {required this.returnId});
}

class ReturnResolutionSaved extends ReturnResolutionState {
  final SavedReturnResolution resolution;

  const ReturnResolutionSaved(super.pendingReturns, {required this.resolution});
}

class ReturnResolutionFailure extends ReturnResolutionState {
  final String message;

  const ReturnResolutionFailure(super.pendingReturns, {required this.message});
}
