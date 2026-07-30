import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/returns/data/mappers/warehouse_return_firestore_mapper.dart';
import 'package:stock_take/features/returns/data/models/warehouse_return_record.dart';

void main() {
  test('maps a valid Firestore return snapshot', () {
    final receivedAt = DateTime(2026, 7, 30, 11);

    final warehouseReturn = WarehouseReturnFirestoreMapper.fromMap(
      id: 'return-1',
      data: {
        'returnNumber': 'RET-2026-000001',
        'itemId': 'item-1',
        'itemNameSnapshot': 'صنف',
        'itemCodeSnapshot': 'ITM-001',
        'itemsPerCartonSnapshot': 12,
        'quantityPieces': 25,
        'sourceName': 'عميل',
        'status': 'pendingSupplierResolution',
        'receivedAt': Timestamp.fromDate(receivedAt),
      },
    );

    expect(
      warehouseReturn.status,
      WarehouseReturnStatus.pendingSupplierResolution,
    );
    expect(warehouseReturn.receivedAt, receivedAt);
    expect(warehouseReturn.itemsPerCarton, 12);
  });

  test('rejects a non-positive carton size', () {
    expect(
      () => WarehouseReturnFirestoreMapper.fromMap(
        id: 'return-1',
        data: {
          'returnNumber': 'RET-2026-000001',
          'itemId': 'item-1',
          'itemNameSnapshot': 'صنف',
          'itemCodeSnapshot': 'ITM-001',
          'itemsPerCartonSnapshot': 0,
          'quantityPieces': 25,
          'sourceName': 'عميل',
          'status': 'pendingSupplierResolution',
          'receivedAt': Timestamp.now(),
        },
      ),
      throwsFormatException,
    );
  });

  test('rejects unknown return statuses as malformed Firestore data', () {
    expect(
      () => WarehouseReturnFirestoreMapper.fromMap(
        id: 'return-1',
        data: {
          'returnNumber': 'RET-2026-000001',
          'itemId': 'item-1',
          'itemNameSnapshot': 'صنف',
          'itemCodeSnapshot': 'ITM-001',
          'itemsPerCartonSnapshot': 12,
          'quantityPieces': 25,
          'sourceName': 'عميل',
          'status': 'unknown',
          'receivedAt': Timestamp.now(),
        },
      ),
      throwsFormatException,
    );
  });
}
