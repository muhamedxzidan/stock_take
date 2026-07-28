import '../models/inventory_movement.dart';
import '../models/movement_record.dart';
import '../models/transaction_model.dart';

abstract class TransactionsRepositoryBase {
  Stream<List<MovementRecord>> watchMovements();

  Future<SavedInventoryMovement> createInboundMovement(
    InventoryMovementDraft draft,
  );

  Future<SavedInventoryMovement> createOutboundMovement(
    InventoryMovementDraft draft,
  );

  /// Record a new transaction (Inbound / Outbound / Adjustment).
  Future<void> createTransaction(TransactionModel transaction);

  /// Fetch all historical transactions log.
  Future<List<TransactionModel>> fetchTransactions();
}
