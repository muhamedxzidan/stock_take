enum ReturnItemCondition { readyForStock, damaged, needsInspection }

class WarehouseReturnDraft {
  final String originalVoucherNumber;
  final String sourceName;
  final String itemId;
  final String itemName;
  final String itemCode;
  final int quantityPieces;
  final String returnedBy;
  final String receivedBy;
  final DateTime receivedAt;
  final String reason;
  final String notes;
  final ReturnItemCondition condition;

  const WarehouseReturnDraft({
    required this.originalVoucherNumber,
    required this.sourceName,
    required this.itemId,
    required this.itemName,
    required this.itemCode,
    required this.quantityPieces,
    required this.returnedBy,
    required this.receivedBy,
    required this.receivedAt,
    required this.reason,
    required this.notes,
    required this.condition,
  });
}

class SavedWarehouseReturn {
  final String returnId;
  final String returnNumber;
  final String itemCode;
  final int quantityPieces;

  const SavedWarehouseReturn({
    required this.returnId,
    required this.returnNumber,
    required this.itemCode,
    required this.quantityPieces,
  });
}
