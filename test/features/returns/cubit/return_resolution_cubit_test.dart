import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/returns/cubit/return_resolution_cubit.dart';
import 'package:stock_take/features/returns/cubit/return_resolution_state.dart';
import 'package:stock_take/features/returns/data/models/return_resolution.dart';
import 'package:stock_take/features/returns/data/models/warehouse_return_draft.dart';
import 'package:stock_take/features/returns/data/models/warehouse_return_record.dart';

import '../../../support/fake_returns_repository.dart';

void main() {
  late FakeReturnsRepository repository;
  late ReturnResolutionCubit cubit;

  setUp(() {
    repository = FakeReturnsRepository(pendingReturns: [_pendingReturn()]);
    cubit = ReturnResolutionCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await repository.close();
  });

  test('loads pending returns and resolves one only once', () async {
    final loaded = expectLater(
      cubit.stream,
      emitsThrough(
        isA<ReturnResolutionReady>().having(
          (state) => state.pendingReturns,
          'pending returns',
          hasLength(1),
        ),
      ),
    );
    cubit.loadPendingReturns();
    await loaded;

    final resolution = await cubit.resolveReturn(
      const ReturnResolutionDraft(
        returnId: 'return-1',
        supplierName: 'المورد الرئيسي',
        kind: ReturnResolutionKind.replaced,
      ),
    );

    expect(resolution, isNotNull);
    expect(cubit.state, isA<ReturnResolutionSaved>());
    expect(cubit.state.pendingReturns, isEmpty);
    expect(repository.resolutions, hasLength(1));

    final repeatedResolution = await cubit.resolveReturn(
      const ReturnResolutionDraft(
        returnId: 'return-1',
        supplierName: 'المورد الرئيسي',
        kind: ReturnResolutionKind.returnedToSupplier,
      ),
    );

    expect(repeatedResolution, isNull);
    expect(cubit.state, isA<ReturnResolutionFailure>());
    expect(repository.resolutions, hasLength(1));
  });
}

WarehouseReturnRecord _pendingReturn() {
  return WarehouseReturnRecord(
    id: 'return-1',
    returnNumber: 'RET-2026-000001',
    originalVoucherNumber: 'OUT-2026-000001',
    itemId: 'ITM-001',
    itemName: 'صنف اختبار',
    itemCode: 'ITM-001',
    quantityPieces: 3,
    sourceName: 'فرع اختبار',
    returnedBy: 'مسؤول الفرع',
    receivedBy: 'أمين المخزن',
    reason: 'كمية زائدة',
    notes: '',
    condition: ReturnItemCondition.needsInspection,
    status: WarehouseReturnStatus.pendingSupplierResolution,
    receivedAt: DateTime(2026, 7, 28),
  );
}
