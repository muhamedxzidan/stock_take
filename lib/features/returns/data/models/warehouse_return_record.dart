import 'warehouse_return_draft.dart';

enum WarehouseReturnStatus {
  pendingSupplierResolution,
  replaced,
  returnedToSupplier,
}

class WarehouseReturnRecord {
  final String id;
  final String returnNumber;
  final String originalVoucherNumber;
  final String itemId;
  final String itemName;
  final String itemCode;
  final int quantityPieces;
  final String sourceName;
  final String returnedBy;
  final String receivedBy;
  final String reason;
  final String notes;
  final ReturnItemCondition condition;
  final WarehouseReturnStatus status;
  final DateTime receivedAt;

  const WarehouseReturnRecord({
    required this.id,
    required this.returnNumber,
    required this.originalVoucherNumber,
    required this.itemId,
    required this.itemName,
    required this.itemCode,
    required this.quantityPieces,
    required this.sourceName,
    required this.returnedBy,
    required this.receivedBy,
    required this.reason,
    required this.notes,
    required this.condition,
    required this.status,
    required this.receivedAt,
  });
}
