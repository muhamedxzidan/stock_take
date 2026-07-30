import '../data/models/inventory_movement.dart';

sealed class TransactionsState {}

class TransactionsInitial extends TransactionsState {}

class InventoryMovementSaving extends TransactionsState {}

class InventoryMovementSaved extends TransactionsState {
  final SavedInventoryMovement movement;

  InventoryMovementSaved(this.movement);
}

class InventoryMovementFailure extends TransactionsState {
  final String message;

  InventoryMovementFailure(this.message);
}
