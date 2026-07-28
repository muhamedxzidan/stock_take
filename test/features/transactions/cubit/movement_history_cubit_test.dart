import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/transactions/cubit/movement_history_cubit.dart';
import 'package:stock_take/features/transactions/cubit/movement_history_state.dart';
import 'package:stock_take/features/transactions/data/models/movement_record.dart';

import '../../../support/fake_transactions_repository.dart';

void main() {
  late FakeTransactionsRepository repository;
  late MovementHistoryCubit cubit;

  setUp(() {
    repository = FakeTransactionsRepository(movements: _movements());
    cubit = MovementHistoryCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await repository.close();
  });

  test('builds report totals from the visible movement source', () async {
    final loaded = expectLater(
      cubit.stream,
      emitsThrough(
        isA<MovementHistorySuccess>().having(
          (state) => state.movements,
          'movements',
          hasLength(4),
        ),
      ),
    );
    cubit.loadMovements();
    await loaded;

    final state = cubit.state as MovementHistorySuccess;
    expect(state.summary.movementCount, 4);
    expect(state.summary.inboundPieces, 20);
    expect(state.summary.outboundPieces, 5);
    expect(state.summary.customerReturnPieces, 3);
    expect(state.summary.supplierReplacementCount, 1);
  });

  test(
    'filters by type, numeric item code, and inclusive date range',
    () async {
      final loaded = expectLater(
        cubit.stream,
        emitsThrough(isA<MovementHistorySuccess>()),
      );
      cubit.loadMovements();
      await loaded;

      cubit.filterByType(MovementRecordType.inbound);
      expect(
        (cubit.state as MovementHistorySuccess).movements.single.type,
        MovementRecordType.inbound,
      );

      cubit.filterByType(null);
      cubit.onSearchChanged('١٢');
      await Future<void>.delayed(const Duration(milliseconds: 350));
      expect((cubit.state as MovementHistorySuccess).movements, hasLength(2));

      cubit.onSearchChanged('');
      await Future<void>.delayed(const Duration(milliseconds: 350));
      cubit.setDateRange(
        from: DateTime(2026, 7, 27),
        to: DateTime(2026, 7, 28),
      );
      expect((cubit.state as MovementHistorySuccess).movements, hasLength(3));
    },
  );
}

List<MovementRecord> _movements() {
  return [
    _movement(
      id: '1',
      voucherNumber: 'IN-2026-000001',
      type: MovementRecordType.inbound,
      date: DateTime(2026, 7, 28),
      code: 'S-N-1',
      delta: 20,
    ),
    _movement(
      id: '2',
      voucherNumber: 'OUT-2026-000001',
      type: MovementRecordType.outbound,
      date: DateTime(2026, 7, 28),
      code: 'S-N-2',
      delta: -5,
    ),
    _movement(
      id: '3',
      voucherNumber: 'RET-2026-000001',
      type: MovementRecordType.customerReturn,
      date: DateTime(2026, 7, 27),
      code: 'S-N-12',
      delta: 3,
    ),
    _movement(
      id: '4',
      voucherNumber: 'RS-2026-000001',
      type: MovementRecordType.supplierReplacement,
      date: DateTime(2026, 7, 26),
      code: 'S-N-12',
      delta: 0,
    ),
  ];
}

MovementRecord _movement({
  required String id,
  required String voucherNumber,
  required MovementRecordType type,
  required DateTime date,
  required String code,
  required int delta,
}) {
  return MovementRecord(
    id: id,
    voucherNumber: voucherNumber,
    type: type,
    businessAt: date,
    partyName: 'جهة اختبار',
    deliveredBy: 'مسؤول',
    receivedBy: 'أمين المخزن',
    driverName: '',
    notes: '',
    lines: [
      MovementRecordLine(
        itemId: code,
        itemCode: code,
        itemName: 'صنف $code',
        unit: 'piece',
        itemsPerCarton: 12,
        cartons: 0,
        pieces: delta.abs(),
        totalPieces: delta.abs(),
      ),
    ],
    itemDeltas: {code: delta},
  );
}
