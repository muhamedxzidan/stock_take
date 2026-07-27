enum ReturnItemCondition { readyForStock, damaged, needsInspection }

/// Typed UI input prepared for a future ReturnsCubit.
///
/// This class does not persist data or apply any stock rules.
class WarehouseReturnDraft {
  final String originalVoucherNumber;
  final String returnSource;
  final String itemName;
  final String itemCode;
  final int? quantity;
  final String returnedBy;
  final String receivedBy;
  final String returnDate;
  final String reason;
  final String notes;
  final ReturnItemCondition condition;

  const WarehouseReturnDraft({
    required this.originalVoucherNumber,
    required this.returnSource,
    required this.itemName,
    required this.itemCode,
    required this.quantity,
    required this.returnedBy,
    required this.receivedBy,
    required this.returnDate,
    required this.reason,
    required this.notes,
    required this.condition,
  });
}
