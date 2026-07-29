import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/transactions/cubit/transactions_cubit.dart';
import 'package:stock_take/features/transactions/cubit/transactions_state.dart';
import 'package:stock_take/features/transactions/data/models/inventory_movement.dart';

import '../../../support/fake_transactions_repository.dart';

void main() {
  late FakeTransactionsRepository repository;
  late TransactionsCubit cubit;

  setUp(() {
    repository = FakeTransactionsRepository();
    cubit = TransactionsCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await repository.close();
  });

  test('saves a valid inbound voucher through the repository', () async {
    final movement = await cubit.createInboundMovement(_validDraft());

    expect(movement, isNotNull);
    expect(movement!.voucherNumber, 'IN-2026-000001');
    expect(cubit.state, isA<InventoryMovementSaved>());
    expect(repository.inboundDrafts, hasLength(1));
    expect(repository.inboundDrafts.single.lines.single.totalPieces, 26);
  });

  test('rejects duplicate items before calling the repository', () async {
    final line = _validDraft().lines.single;
    final draft = InventoryMovementDraft(
      lines: [line, line],
      partyName: 'شركة النيل',
      deliveredBy: '',
      receivedBy: '',
      driverName: '',
      notes: '',
      businessDate: DateTime(2026, 7, 28),
    );

    final movement = await cubit.createInboundMovement(draft);

    expect(movement, isNull);
    expect(cubit.state, isA<InventoryMovementFailure>());
    expect(repository.inboundDrafts, isEmpty);
  });

  test('saves a valid outbound voucher through the repository', () async {
    final movement = await cubit.createOutboundMovement(_validDraft());

    expect(movement, isNotNull);
    expect(movement!.voucherNumber, 'OUT-2026-000001');
    expect(cubit.state, isA<InventoryMovementSaved>());
    expect(repository.outboundDrafts, hasLength(1));
    expect(repository.outboundDrafts.single.lines.single.totalPieces, 26);
  });

  test(
    'exposes the latest-stock failure when outbound exceeds stock',
    () async {
      final limitedRepository = FakeTransactionsRepository(
        availableStockByItemId: const {'ITM-001': 25},
      );
      final limitedCubit = TransactionsCubit(limitedRepository);
      addTearDown(limitedCubit.close);
      addTearDown(limitedRepository.close);

      final movement = await limitedCubit.createOutboundMovement(_validDraft());

      expect(movement, isNull);
      expect(limitedCubit.state, isA<InventoryMovementFailure>());
      expect(
        (limitedCubit.state as InventoryMovementFailure).message,
        contains('المتاح 25 قطعة فقط'),
      );
      expect(limitedRepository.outboundDrafts, isEmpty);
    },
  );

  test(
    'ignores a duplicate movement while the first save is pending',
    () async {
      final gate = Completer<void>();
      repository.saveDelay = gate.future;

      final firstSave = cubit.createInboundMovement(_validDraft());
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<InventoryMovementSaving>());
      final duplicateSave = await cubit.createInboundMovement(_validDraft());

      expect(duplicateSave, isNull);
      expect(repository.inboundDrafts, isEmpty);

      gate.complete();
      expect(await firstSave, isNotNull);
      expect(repository.inboundDrafts, hasLength(1));
    },
  );
}

InventoryMovementDraft _validDraft() {
  return InventoryMovementDraft(
    lines: const [
      InventoryMovementLine(
        itemId: 'ITM-001',
        itemCode: 'ITM-001',
        itemName: 'زيت دوار الشمس',
        unit: 'piece',
        itemsPerCarton: 12,
        cartons: 2,
        pieces: 2,
      ),
    ],
    partyName: 'شركة النيل',
    deliveredBy: 'أحمد',
    receivedBy: 'محمد',
    driverName: '',
    notes: '',
    businessDate: DateTime(2026, 7, 28),
  );
}
