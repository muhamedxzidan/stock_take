import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/core/models/inventory_item.dart';

void main() {
  const item = InventoryItem(
    id: 'S-N-12',
    code: 'S-N-12',
    name: 'مياه معدنية',
    unit: 'piece',
    itemsPerCarton: 24,
    openingStockPieces: 48,
    currentStockPieces: 48,
    totalInboundPieces: 0,
    totalOutboundPieces: 0,
    totalCustomerReturnPieces: 0,
    totalSupplierReturnPieces: 0,
    totalAdjustmentPieces: 0,
    active: true,
  );

  test(
    'matches an item by numeric code suffix while keeping the full code',
    () {
      expect(item.code, 'S-N-12');
      expect(item.matchesSearch('12'), isTrue);
      expect(item.matchesSearch('١٢'), isTrue);
      expect(item.matchesSearch('S-N-12'), isTrue);
      expect(item.matchesSearch('مياه'), isTrue);
      expect(item.matchesSearch('13'), isFalse);
    },
  );
}
