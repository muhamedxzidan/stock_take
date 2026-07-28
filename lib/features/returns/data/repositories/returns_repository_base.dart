import '../models/return_resolution.dart';
import '../models/warehouse_return_draft.dart';
import '../models/warehouse_return_record.dart';

abstract class ReturnsRepositoryBase {
  Stream<List<WarehouseReturnRecord>> watchPendingReturns();

  Future<SavedWarehouseReturn> createCustomerReturn(WarehouseReturnDraft draft);

  Future<SavedReturnResolution> resolveReturn(ReturnResolutionDraft draft);
}
