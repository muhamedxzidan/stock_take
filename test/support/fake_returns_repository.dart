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
    drafts.add(draft);
    final sequence = _nextReturnNumber++;
    final savedReturn = SavedWarehouseReturn(
      returnId: 'return-$sequence',
      returnNumber:
          'RET-${draft.receivedAt.year}-${sequence.toString().padLeft(6, '0')}',
      itemCode: draft.itemCode,
      quantityPieces: draft.quantityPieces,
    );
    _pendingReturns.add(
      WarehouseReturnRecord(
        id: savedReturn.returnId,
        returnNumber: savedReturn.returnNumber,
        originalVoucherNumber: draft.originalVoucherNumber,
        itemId: draft.itemId,
        itemName: draft.itemName,
        itemCode: draft.itemCode,
        quantityPieces: draft.quantityPieces,
        sourceName: draft.sourceName,
        returnedBy: draft.returnedBy,
        receivedBy: draft.receivedBy,
        reason: draft.reason,
        notes: draft.notes,
        condition: draft.condition,
        status: WarehouseReturnStatus.pendingSupplierResolution,
        receivedAt: draft.receivedAt,
      ),
    );
    _controller.add(_visiblePendingReturns);
    return savedReturn;
  }

  @override
  Future<SavedReturnResolution> resolveReturn(
    ReturnResolutionDraft draft,
  ) async {
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
