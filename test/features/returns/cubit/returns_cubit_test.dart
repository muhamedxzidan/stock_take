import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/returns/cubit/returns_cubit.dart';
import 'package:stock_take/features/returns/cubit/returns_state.dart';
import 'package:stock_take/features/returns/data/models/warehouse_return_draft.dart';

import '../../../support/fake_returns_repository.dart';

void main() {
  late FakeReturnsRepository repository;
  late ReturnsCubit cubit;

  setUp(() {
    repository = FakeReturnsRepository();
    cubit = ReturnsCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await repository.close();
  });

  test('saves a valid customer return through the repository', () async {
    final savedReturn = await cubit.createCustomerReturn(_validDraft());

    expect(savedReturn, isNotNull);
    expect(savedReturn!.returnNumber, 'RET-2026-000001');
    expect(cubit.state, isA<ReturnsSaved>());
    expect(repository.drafts, hasLength(1));
    expect(repository.drafts.single.quantityPieces, 12);
  });

  test('rejects missing required return data before persistence', () async {
    final draft = WarehouseReturnDraft(
      originalVoucherNumber: '',
      sourceName: '',
      itemId: 'S-N-1',
      itemName: 'صنف اختبار',
      itemCode: 'S-N-1',
      quantityPieces: 12,
      returnedBy: '',
      receivedBy: '',
      receivedAt: DateTime(2026, 7, 28),
      reason: '',
      notes: '',
      condition: ReturnItemCondition.needsInspection,
    );

    final savedReturn = await cubit.createCustomerReturn(draft);

    expect(savedReturn, isNull);
    expect(cubit.state, isA<ReturnsFailure>());
    expect(repository.drafts, isEmpty);
  });
}

WarehouseReturnDraft _validDraft() {
  return WarehouseReturnDraft(
    originalVoucherNumber: 'OUT-2026-000001',
    sourceName: 'فرع مدينة نصر',
    itemId: 'S-N-1',
    itemName: 'صنف اختبار',
    itemCode: 'S-N-1',
    quantityPieces: 12,
    returnedBy: 'مسؤول الفرع',
    receivedBy: 'أمين المخزن',
    receivedAt: DateTime(2026, 7, 28),
    reason: 'كمية زائدة',
    notes: '',
    condition: ReturnItemCondition.needsInspection,
  );
}
