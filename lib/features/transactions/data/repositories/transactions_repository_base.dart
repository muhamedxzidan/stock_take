import '../models/inventory_movement.dart';
import '../models/movement_record.dart';

abstract class TransactionsRepositoryBase {
  Stream<List<MovementRecord>> watchMovements();

  Future<SavedInventoryMovement> createInboundMovement(
    InventoryMovementDraft draft,
  );

  Future<SavedInventoryMovement> createOutboundMovement(
    InventoryMovementDraft draft,
  );
}
