import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/transactions/data/mappers/movement_receipt_mapper.dart';
import 'package:stock_take/features/transactions/data/models/inventory_movement.dart';
import 'package:stock_take/features/transactions/data/models/movement_record.dart';

void main() {
  test('maps a saved movement with cartons as the primary quantity', () {
    final receipt = MovementReceiptMapper.fromSavedMovement(
      savedMovement: const SavedInventoryMovement(
        movementId: 'movement-1',
        voucherNumber: 'IN-2026-000001',
      ),
      draft: InventoryMovementDraft(
        lines: const [
          InventoryMovementLine(
            itemId: 'item-1',
            itemCode: 'S-N-1',
            itemName: 'مياه',
            unit: 'piece',
            itemsPerCarton: 12,
            cartons: 2,
            pieces: 3,
          ),
        ],
        partyName: 'المورد الرئيسي',
        deliveredBy: 'أحمد',
        receivedBy: 'محمد',
        driverName: '',
        notes: '',
        businessDate: DateTime(2026, 7, 29),
      ),
      movementLabel: 'إذن وارد',
      partyLabel: 'المورد',
    );

    expect(receipt.voucherNumber, 'IN-2026-000001');
    expect(receipt.lines.single.cartons, 2);
    expect(receipt.lines.single.loosePieces, 3);
    expect(receipt.lines.single.totalPieces, 27);
    expect(receipt.totalCartons, 2);
    expect(receipt.totalPieces, 27);
  });

  test('maps supplier returns as an outgoing supplier receipt', () {
    final receipt = MovementReceiptMapper.fromMovementRecord(
      MovementRecord(
        id: 'return-1',
        voucherNumber: 'SRET-2026-000001',
        type: MovementRecordType.supplierReturn,
        businessAt: DateTime(2026, 7, 29),
        partyName: 'المورد الرئيسي',
        deliveredBy: 'أمين المخزن',
        receivedBy: 'مندوب المورد',
        driverName: '',
        notes: '',
        lines: const [
          MovementRecordLine(
            itemId: 'item-1',
            itemCode: 'S-N-1',
            itemName: 'مياه',
            unit: 'piece',
            itemsPerCarton: 12,
            cartons: 1,
            pieces: 0,
            totalPieces: 12,
          ),
        ],
        itemDeltas: const {'item-1': -12},
      ),
    );

    expect(receipt.movementLabel, 'مرتجع إلى المورد');
    expect(receipt.partyLabel, 'المورد');
    expect(receipt.totalCartons, 1);
    expect(receipt.totalPieces, 12);
  });
}
