import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/warehouse_return_draft.dart';
import '../data/repositories/returns_repository_base.dart';
import '../data/repositories/returns_repository_failure.dart';
import 'returns_state.dart';

class ReturnsCubit extends Cubit<ReturnsState> {
  final ReturnsRepositoryBase _repository;
  bool _isSaving = false;

  ReturnsCubit(this._repository) : super(ReturnsInitial());

  Future<SavedWarehouseReturn?> createCustomerReturn(
    WarehouseReturnDraft draft,
  ) async {
    if (_isSaving) {
      return null;
    }

    final validationMessage = _validateDraft(draft);
    if (validationMessage != null) {
      emit(ReturnsFailure(validationMessage));
      return null;
    }

    _isSaving = true;
    emit(ReturnsSaving());
    try {
      final savedReturn = await _repository.createCustomerReturn(draft);
      emit(ReturnsSaved(savedReturn));
      return savedReturn;
    } on ReturnsRepositoryFailure catch (failure) {
      emit(ReturnsFailure(failure.message));
      return null;
    } catch (_) {
      emit(ReturnsFailure('تعذر حفظ المرتجع الآن.'));
      return null;
    } finally {
      _isSaving = false;
    }
  }

  String? _validateDraft(WarehouseReturnDraft draft) {
    if (draft.itemId.trim().isEmpty ||
        draft.itemName.trim().isEmpty ||
        draft.itemCode.trim().isEmpty) {
      return 'اختر الصنف المرتجع.';
    }
    if (draft.quantityPieces <= 0) {
      return 'اكتب كمية مرتجعة صحيحة.';
    }
    if (draft.sourceName.trim().isEmpty || draft.sourceName.length > 200) {
      return 'اكتب اسم الجهة أو الشخص الذي أعاد الصنف.';
    }
    return null;
  }
}
