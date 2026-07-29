class WarehouseReturnDraft {
  final String sourceName;
  final String itemId;
  final String itemName;
  final String itemCode;
  final int quantityPieces;

  const WarehouseReturnDraft({
    required this.sourceName,
    required this.itemId,
    required this.itemName,
    required this.itemCode,
    required this.quantityPieces,
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
