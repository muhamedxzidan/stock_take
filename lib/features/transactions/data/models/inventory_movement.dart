class InventoryMovementLine {
  final String itemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final int itemsPerCarton;
  final int cartons;
  final int pieces;

  const InventoryMovementLine({
    required this.itemId,
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.itemsPerCarton,
    required this.cartons,
    required this.pieces,
  });

  int get totalPieces => (cartons * itemsPerCarton) + pieces;
}

class InventoryMovementDraft {
  final List<InventoryMovementLine> lines;
  final String partyName;
  final String deliveredBy;
  final String receivedBy;
  final String driverName;
  final String notes;
  final DateTime businessDate;

  const InventoryMovementDraft({
    required this.lines,
    required this.partyName,
    required this.deliveredBy,
    required this.receivedBy,
    required this.driverName,
    required this.notes,
    required this.businessDate,
  });
}

class SavedInventoryMovement {
  final String movementId;
  final String voucherNumber;

  const SavedInventoryMovement({
    required this.movementId,
    required this.voucherNumber,
  });
}
