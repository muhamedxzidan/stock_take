import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/core/models/inventory_item.dart';
import 'package:stock_take/features/dashboard/data/mappers/stock_balance_receipt_mapper.dart';

void main() {
  test('maps every inventory item into one stock balance receipt', () {
    const items = <InventoryItem>[
      InventoryItem(
        id: 'item-1',
        code: 'ITM-001',
        name: 'صنف برصيد',
        unit: 'piece',
        itemsPerCarton: 12,
        openingStockPieces: 27,
        currentStockPieces: 27,
        totalInboundPieces: 0,
        totalOutboundPieces: 0,
        totalCustomerReturnPieces: 0,
        totalSupplierReturnPieces: 0,
        totalAdjustmentPieces: 0,
        active: true,
      ),
      InventoryItem(
        id: 'item-2',
        code: 'ITM-002',
        name: 'صنف رصيده صفر',
        unit: 'piece',
        itemsPerCarton: 10,
        openingStockPieces: 0,
        currentStockPieces: 0,
        totalInboundPieces: 0,
        totalOutboundPieces: 0,
        totalCustomerReturnPieces: 0,
        totalSupplierReturnPieces: 0,
        totalAdjustmentPieces: 0,
        active: true,
      ),
    ];

    final receipt = StockBalanceReceiptMapper.fromItems(
      items: items,
      generatedAt: DateTime(2026, 7, 30, 14, 5),
    );

    expect(receipt.documentTitle, 'كشف رصيد المخزن');
    expect(receipt.voucherNumber, 'STOCK-20260730-1405');
    expect(receipt.date, '2026-07-30 14:05');
    expect(receipt.lines, hasLength(2));
    expect(receipt.lines.first.itemName, 'صنف برصيد');
    expect(receipt.lines.first.cartons, 2);
    expect(receipt.lines.first.loosePieces, 3);
    expect(receipt.lines.first.totalPieces, 27);
    expect(receipt.lines.last.itemName, 'صنف رصيده صفر');
    expect(receipt.lines.last.cartons, 0);
    expect(receipt.lines.last.loosePieces, 0);
    expect(receipt.lines.last.totalPieces, 0);
    expect(receipt.notes, 'عدد الأصناف: 2');
  });
}
