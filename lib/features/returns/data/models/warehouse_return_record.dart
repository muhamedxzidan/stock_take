enum WarehouseReturnStatus {
  pendingSupplierResolution,
  replaced,
  returnedToSupplier,
}

class WarehouseReturnRecord {
  final String id;
  final String returnNumber;
  final String itemId;
  final String itemName;
  final String itemCode;
  final int? itemsPerCarton;
  final int quantityPieces;
  final String sourceName;
  final WarehouseReturnStatus status;
  final DateTime receivedAt;

  const WarehouseReturnRecord({
    required this.id,
    required this.returnNumber,
    required this.itemId,
    required this.itemName,
    required this.itemCode,
    required this.itemsPerCarton,
    required this.quantityPieces,
    required this.sourceName,
    required this.status,
    required this.receivedAt,
  });
}
