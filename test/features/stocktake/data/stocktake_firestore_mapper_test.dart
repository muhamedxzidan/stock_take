import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/stocktake/data/mappers/stocktake_firestore_mapper.dart';
import 'package:stock_take/features/stocktake/data/models/stocktake_session.dart';

void main() {
  test('maps valid stocktake session and line snapshots', () {
    final startedAt = DateTime(2026, 7, 30, 8);
    final countedAt = DateTime(2026, 7, 30, 9);

    final session = StocktakeFirestoreMapper.sessionFromMap(
      id: 'stocktake-1',
      data: {
        'stocktakeNumber': 'STK-2026-000001',
        'status': 'open',
        'periodFrom': Timestamp.fromDate(DateTime(2026, 7, 1)),
        'periodTo': Timestamp.fromDate(DateTime(2026, 7, 30)),
        'startedAt': Timestamp.fromDate(startedAt),
        'completedAt': null,
        'cancelledAt': null,
        'notes': '',
      },
    );
    final line = StocktakeFirestoreMapper.lineFromMap(
      itemId: 'item-1',
      data: {
        'itemId': 'item-1',
        'itemNameSnapshot': 'صنف',
        'itemCodeSnapshot': 'ITM-001',
        'unit': 'قطعة',
        'itemsPerCarton': 12,
        'systemQuantityPieces': 25,
        'actualQuantityPieces': 24,
        'differencePieces': -1,
        'counted': true,
        'countedAt': Timestamp.fromDate(countedAt),
      },
    );

    expect(session.status, StocktakeStatus.open);
    expect(session.startedAt, startedAt);
    expect(line.differencePieces, -1);
    expect(line.countedAt, countedAt);
  });

  test(
    'rejects a line whose stored item id does not match its document id',
    () {
      expect(
        () => StocktakeFirestoreMapper.lineFromMap(
          itemId: 'item-1',
          data: {
            'itemId': 'item-2',
            'itemNameSnapshot': 'صنف',
            'itemCodeSnapshot': 'ITM-001',
            'unit': 'قطعة',
            'itemsPerCarton': 12,
            'systemQuantityPieces': 25,
            'actualQuantityPieces': 24,
            'differencePieces': -1,
            'counted': true,
            'countedAt': Timestamp.now(),
          },
        ),
        throwsFormatException,
      );
    },
  );

  test('rejects unknown stocktake statuses as malformed Firestore data', () {
    expect(
      () => StocktakeFirestoreMapper.sessionFromMap(
        id: 'stocktake-1',
        data: {
          'stocktakeNumber': 'STK-2026-000001',
          'status': 'unknown',
          'periodFrom': Timestamp.now(),
          'periodTo': Timestamp.now(),
          'startedAt': Timestamp.now(),
          'completedAt': null,
          'cancelledAt': null,
          'notes': '',
        },
      ),
      throwsFormatException,
    );
  });
}
