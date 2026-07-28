import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/return_resolution.dart';
import '../data/models/warehouse_return_record.dart';
import '../data/repositories/returns_repository_base.dart';
import '../data/repositories/returns_repository_failure.dart';
import 'return_resolution_state.dart';

class ReturnResolutionCubit extends Cubit<ReturnResolutionState> {
  final ReturnsRepositoryBase _repository;
  StreamSubscription<List<WarehouseReturnRecord>>? _subscription;
  List<WarehouseReturnRecord> _pendingReturns = const [];
  String? _resolvingReturnId;

  ReturnResolutionCubit(this._repository)
    : super(const ReturnResolutionInitial());

  void loadPendingReturns() {
    if (_subscription != null) {
      return;
    }

    emit(const ReturnResolutionLoading());
    _subscription = _repository.watchPendingReturns().listen(
      (returns) {
        _pendingReturns = List.unmodifiable(returns);
        final resolvingReturnId = _resolvingReturnId;
        if (resolvingReturnId == null) {
          emit(ReturnResolutionReady(_pendingReturns));
        } else {
          emit(
            ReturnResolutionSaving(
              _pendingReturns,
              returnId: resolvingReturnId,
            ),
          );
        }
      },
      onError: (Object error) {
        _subscription?.cancel();
        _subscription = null;
        final message = error is ReturnsRepositoryFailure
            ? error.message
            : 'تعذر تحميل المرتجعات الآن.';
        emit(ReturnResolutionFailure(_pendingReturns, message: message));
      },
    );
  }

  Future<SavedReturnResolution?> resolveReturn(
    ReturnResolutionDraft draft,
  ) async {
    if (_resolvingReturnId != null) {
      return null;
    }
    if (draft.supplierName.trim().isEmpty || draft.supplierName.length > 200) {
      emit(
        ReturnResolutionFailure(
          _pendingReturns,
          message: 'اكتب اسم المورد بشكل صحيح.',
        ),
      );
      return null;
    }
    if (!_pendingReturns.any((item) => item.id == draft.returnId)) {
      emit(
        ReturnResolutionFailure(
          _pendingReturns,
          message: 'المرتجع لم يعد ضمن المرتجعات المعلقة.',
        ),
      );
      return null;
    }

    _resolvingReturnId = draft.returnId;
    emit(ReturnResolutionSaving(_pendingReturns, returnId: draft.returnId));
    try {
      final resolution = await _repository.resolveReturn(draft);
      _pendingReturns = List.unmodifiable(
        _pendingReturns.where((item) => item.id != draft.returnId),
      );
      emit(ReturnResolutionSaved(_pendingReturns, resolution: resolution));
      return resolution;
    } on ReturnsRepositoryFailure catch (failure) {
      emit(ReturnResolutionFailure(_pendingReturns, message: failure.message));
      return null;
    } catch (_) {
      emit(
        ReturnResolutionFailure(
          _pendingReturns,
          message: 'تعذر تسوية المرتجع الآن.',
        ),
      );
      return null;
    } finally {
      _resolvingReturnId = null;
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
