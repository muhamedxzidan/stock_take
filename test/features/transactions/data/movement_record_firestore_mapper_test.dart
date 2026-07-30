import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/transactions/data/mappers/movement_record_firestore_mapper.dart';
import 'package:stock_take/features/transactions/data/models/movement_record.dart';

void main() {
  test('maps a valid Firestore movement snapshot', () {
    final businessAt = DateTime(2026, 7, 30, 10);

    final movement = MovementRecordFirestoreMapper.fromMap(
      id: 'movement-1',
      data: {
        'voucherNumber': 'IN-2026-000001',
        'type': 'inbound',
        'businessAt': Timestamp.fromDate(businessAt),
        'partyName': 'المورد',
        'deliveredBy': 'أحمد',
        'receivedBy': 'محمد',
        'driverName': '',
        'notes': '',
        'lines': [
          {
            'itemId': 'item-1',
            'itemCode': 'ITM-001',
            'itemName': 'صنف',
            'unit': 'قطعة',
            'itemsPerCarton': 12,
            'cartons': 2,
            'pieces': 1,
            'totalPieces': 25,
          },
        ],
        'itemDeltas': {'item-1': 25},
      },
    );

    expect(movement.type, MovementRecordType.inbound);
    expect(movement.businessAt, businessAt);
    expect(movement.lines.single.totalPieces, 25);
    expect(movement.itemDeltas, {'item-1': 25});
  });

  test('rejects malformed line snapshots', () {
    expect(
      () => MovementRecordFirestoreMapper.fromMap(
        id: 'movement-1',
        data: {
          'voucherNumber': 'IN-2026-000001',
          'type': 'inbound',
          'businessAt': Timestamp.now(),
          'partyName': 'المورد',
          'deliveredBy': '',
          'receivedBy': '',
          'driverName': '',
          'notes': '',
          'lines': [
            {'itemId': 'item-1'},
          ],
          'itemDeltas': {'item-1': 1},
        },
      ),
      throwsFormatException,
    );
  });

  test('rejects unknown movement types as malformed Firestore data', () {
    expect(
      () => MovementRecordFirestoreMapper.fromMap(
        id: 'movement-1',
        data: {
          'voucherNumber': 'IN-2026-000001',
          'type': 'unknown',
          'businessAt': Timestamp.now(),
          'partyName': 'المورد',
          'deliveredBy': '',
          'receivedBy': '',
          'driverName': '',
          'notes': '',
          'lines': const [],
          'itemDeltas': const <String, int>{},
        },
      ),
      throwsFormatException,
    );
  });
}
