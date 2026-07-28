import '../data/models/inventory_movement.dart';
import '../data/models/transaction_model.dart';

sealed class TransactionsState {}

class TransactionsInitial extends TransactionsState {}

class TransactionsLoading extends TransactionsState {}

class TransactionsSuccess extends TransactionsState {
  final List<TransactionModel> transactions;
  final TransactionType? selectedFilter;

  TransactionsSuccess({required this.transactions, this.selectedFilter});
}

class TransactionsFailure extends TransactionsState {
  final String message;

  TransactionsFailure(this.message);
}

class InventoryMovementSaving extends TransactionsState {}

class InventoryMovementSaved extends TransactionsState {
  final SavedInventoryMovement movement;

  InventoryMovementSaved(this.movement);
}

class InventoryMovementFailure extends TransactionsState {
  final String message;

  InventoryMovementFailure(this.message);
}
