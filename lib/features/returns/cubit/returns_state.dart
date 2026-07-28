import '../data/models/warehouse_return_draft.dart';

sealed class ReturnsState {}

class ReturnsInitial extends ReturnsState {}

class ReturnsSaving extends ReturnsState {}

class ReturnsSaved extends ReturnsState {
  final SavedWarehouseReturn warehouseReturn;

  ReturnsSaved(this.warehouseReturn);
}

class ReturnsFailure extends ReturnsState {
  final String message;

  ReturnsFailure(this.message);
}
