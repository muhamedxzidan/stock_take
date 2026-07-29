import 'dart:async';

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
    expect(savedReturn!.returnNumber, 'RET-${DateTime.now().year}-000001');
    expect(cubit.state, isA<ReturnsSaved>());
    expect(repository.drafts, hasLength(1));
    expect(repository.drafts.single.quantityPieces, 12);
  });

  test('rejects missing required return data before persistence', () async {
    final draft = WarehouseReturnDraft(
      sourceName: '',
      itemId: 'S-N-1',
      itemName: 'صنف اختبار',
      itemCode: 'S-N-1',
      quantityPieces: 12,
    );

    final savedReturn = await cubit.createCustomerReturn(draft);

    expect(savedReturn, isNull);
    expect(cubit.state, isA<ReturnsFailure>());
    expect(repository.drafts, isEmpty);
  });

  test('ignores a duplicate save while the first return is pending', () async {
    final gate = Completer<void>();
    repository.createDelay = gate.future;

    final firstSave = cubit.createCustomerReturn(_validDraft());
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state, isA<ReturnsSaving>());
    final duplicateSave = await cubit.createCustomerReturn(_validDraft());

    expect(duplicateSave, isNull);
    expect(repository.drafts, isEmpty);

    gate.complete();
    expect(await firstSave, isNotNull);
    expect(repository.drafts, hasLength(1));
  });
}

WarehouseReturnDraft _validDraft() {
  return WarehouseReturnDraft(
    sourceName: 'فرع مدينة نصر',
    itemId: 'S-N-1',
    itemName: 'صنف اختبار',
    itemCode: 'S-N-1',
    quantityPieces: 12,
  );
}
