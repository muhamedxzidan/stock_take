import '../../../../core/models/thermal_receipt_data.dart';
import '../models/inventory_movement.dart';
import '../models/movement_record.dart';

class MovementReceiptMapper {
  const MovementReceiptMapper._();

  static ThermalReceiptData fromSavedMovement({
    required SavedInventoryMovement savedMovement,
    required InventoryMovementDraft draft,
    required String movementLabel,
    required String partyLabel,
  }) {
    return ThermalReceiptData(
      voucherNumber: savedMovement.voucherNumber,
      movementLabel: movementLabel,
      date: _formatDate(draft.businessDate),
      partyLabel: partyLabel,
      partyName: draft.partyName,
      deliveredBy: draft.deliveredBy,
      receivedBy: draft.receivedBy,
      driverName: draft.driverName,
      notes: draft.notes,
      lines: draft.lines
          .map(
            (line) => ThermalReceiptLine(
              itemName: line.itemName,
              itemCode: line.itemCode,
              cartons: line.cartons,
              loosePieces: line.pieces,
              totalPieces: line.totalPieces,
            ),
          )
          .toList(growable: false),
    );
  }

  static ThermalReceiptData fromMovementRecord(MovementRecord movement) {
    return ThermalReceiptData(
      voucherNumber: movement.voucherNumber,
      movementLabel: _movementLabel(movement.type),
      date: _formatDate(movement.businessAt),
      partyLabel: _partyLabel(movement.type),
      partyName: movement.partyName,
      deliveredBy: movement.deliveredBy,
      receivedBy: movement.receivedBy,
      driverName: movement.driverName,
      notes: movement.notes,
      lines: movement.lines
          .map(
            (line) => ThermalReceiptLine(
              itemName: line.itemName,
              itemCode: line.itemCode,
              cartons: line.cartons,
              loosePieces: line.pieces,
              totalPieces: line.totalPieces,
            ),
          )
          .toList(growable: false),
    );
  }

  static String _movementLabel(MovementRecordType type) {
    return switch (type) {
      MovementRecordType.inbound => 'إذن وارد',
      MovementRecordType.outbound => 'إذن منصرف',
      MovementRecordType.customerReturn => 'مرتجع عميل',
      MovementRecordType.supplierReturn => 'مرتجع إلى المورد',
      MovementRecordType.supplierReplacement => 'استبدال من المورد',
      MovementRecordType.stocktakeAdjustment => 'تسوية جرد',
    };
  }

  static String _partyLabel(MovementRecordType type) {
    return switch (type) {
      MovementRecordType.inbound ||
      MovementRecordType.supplierReturn ||
      MovementRecordType.supplierReplacement => 'المورد',
      MovementRecordType.outbound => 'الجهة المستلمة',
      MovementRecordType.customerReturn => 'المرتجع من',
      MovementRecordType.stocktakeAdjustment => 'الجهة',
    };
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
