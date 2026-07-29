import 'dart:async';

import 'package:stock_take/features/returns/data/models/return_resolution.dart';
import 'package:stock_take/features/returns/data/models/warehouse_return_draft.dart';
import 'package:stock_take/features/returns/data/models/warehouse_return_record.dart';
import 'package:stock_take/features/returns/data/repositories/returns_repository_base.dart';
import 'package:stock_take/features/returns/data/repositories/returns_repository_failure.dart';

class FakeReturnsRepository implements ReturnsRepositoryBase {
  final StreamController<List<WarehouseReturnRecord>> _controller =
      StreamController<List<WarehouseReturnRecord>>.broadcast();
  final List<WarehouseReturnRecord> _pendingReturns;
  final List<WarehouseReturnDraft> drafts = [];
  final List<ReturnResolutionDraft> resolutions = [];
  Future<void>? createDelay;
  Future<void>? resolutionDelay;
  int _nextReturnNumber = 1;

  FakeReturnsRepository({List<WarehouseReturnRecord> pendingReturns = const []})
    : _pendingReturns = [...pendingReturns];

  @override
  Stream<List<WarehouseReturnRecord>> watchPendingReturns() async* {
    yield _visiblePendingReturns;
    yield* _controller.stream;
  }

  @override
  Future<SavedWarehouseReturn> createCustomerReturn(
    WarehouseReturnDraft draft,
  ) async {
    final delay = createDelay;
    if (delay != null) {
      await delay;
    }
    drafts.add(draft);
    final sequence = _nextReturnNumber++;
    final savedReturn = SavedWarehouseReturn(
      returnId: 'return-$sequence',
      returnNumber:
          'RET-${DateTime.now().year}-${sequence.toString().padLeft(6, '0')}',
      itemCode: draft.itemCode,
      quantityPieces: draft.quantityPieces,
    );
    _pendingReturns.add(
      WarehouseReturnRecord(
        id: savedReturn.returnId,
        returnNumber: savedReturn.returnNumber,
        itemId: draft.itemId,
        itemName: draft.itemName,
        itemCode: draft.itemCode,
        itemsPerCarton: 12,
        quantityPieces: draft.quantityPieces,
        sourceName: draft.sourceName,
        status: WarehouseReturnStatus.pendingSupplierResolution,
        receivedAt: DateTime.now(),
      ),
    );
    _controller.add(_visiblePendingReturns);
    return savedReturn;
  }

  @override
  Future<SavedReturnResolution> resolveReturn(
    ReturnResolutionDraft draft,
  ) async {
    final delay = resolutionDelay;
    if (delay != null) {
      await delay;
    }
    final index = _pendingReturns.indexWhere(
      (warehouseReturn) => warehouseReturn.id == draft.returnId,
    );
    if (index == -1) {
      throw const ReturnsRepositoryFailure('تمت تسوية هذا المرتجع من قبل.');
    }

    final warehouseReturn = _pendingReturns.removeAt(index);
    resolutions.add(draft);
    _controller.add(_visiblePendingReturns);
    return SavedReturnResolution(
      returnId: warehouseReturn.id,
      returnNumber: warehouseReturn.returnNumber,
      movementId: 'resolution-${resolutions.length}',
      kind: draft.kind,
    );
  }

  List<WarehouseReturnRecord> get _visiblePendingReturns =>
      List.unmodifiable(_pendingReturns);

  Future<void> close() => _controller.close();
}
