import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/inventory_movement.dart';
import '../data/repositories/transactions_repository_base.dart';
import '../data/repositories/transactions_repository_failure.dart';
import 'transactions_state.dart';

/// Orchestrates inbound and outbound inventory movement submission.
class TransactionsCubit extends Cubit<TransactionsState> {
  final TransactionsRepositoryBase _repository;
  bool _isSavingMovement = false;

  TransactionsCubit(this._repository) : super(TransactionsInitial());

  Future<SavedInventoryMovement?> createInboundMovement(
    InventoryMovementDraft draft,
  ) {
    return _saveMovement(
      draft: draft,
      movementLabel: 'الوارد',
      invalidPartyMessage: 'اكتب اسم المورد بشكل صحيح.',
      save: _repository.createInboundMovement,
    );
  }

  Future<SavedInventoryMovement?> createOutboundMovement(
    InventoryMovementDraft draft,
  ) {
    return _saveMovement(
      draft: draft,
      movementLabel: 'المنصرف',
      invalidPartyMessage: 'اكتب اسم الجهة المستلمة بشكل صحيح.',
      save: _repository.createOutboundMovement,
    );
  }

  Future<SavedInventoryMovement?> _saveMovement({
    required InventoryMovementDraft draft,
    required String movementLabel,
    required String invalidPartyMessage,
    required Future<SavedInventoryMovement> Function(
      InventoryMovementDraft draft,
    )
    save,
  }) async {
    if (_isSavingMovement) {
      return null;
    }

    final validationMessage = _validateMovementDraft(
      draft,
      movementLabel: movementLabel,
      invalidPartyMessage: invalidPartyMessage,
    );
    if (validationMessage != null) {
      emit(InventoryMovementFailure(validationMessage));
      return null;
    }

    _isSavingMovement = true;
    emit(InventoryMovementSaving());
    try {
      final movement = await save(draft);
      emit(InventoryMovementSaved(movement));
      return movement;
    } on TransactionsRepositoryFailure catch (failure) {
      emit(InventoryMovementFailure(failure.message));
      return null;
    } catch (_) {
      emit(InventoryMovementFailure('تعذر حفظ إذن $movementLabel الآن.'));
      return null;
    } finally {
      _isSavingMovement = false;
    }
  }

  String? _validateMovementDraft(
    InventoryMovementDraft draft, {
    required String movementLabel,
    required String invalidPartyMessage,
  }) {
    if (draft.lines.isEmpty) {
      return 'أضف صنفًا واحدًا على الأقل إلى إذن $movementLabel.';
    }
    if (draft.lines.length > 50) {
      return 'الحد الأقصى للإذن الواحد هو 50 صنفًا.';
    }
    if (draft.partyName.trim().isEmpty || draft.partyName.length > 200) {
      return invalidPartyMessage;
    }
    if (draft.deliveredBy.length > 150 ||
        draft.receivedBy.length > 150 ||
        draft.driverName.length > 150 ||
        draft.notes.length > 1000) {
      return 'إحدى بيانات الإذن أطول من الحد المسموح.';
    }

    final itemIds = <String>{};
    for (final line in draft.lines) {
      if (!itemIds.add(line.itemId)) {
        return 'لا يمكن إضافة الصنف نفسه مرتين داخل الإذن.';
      }
      if (line.cartons < 0 ||
          line.pieces < 0 ||
          line.itemsPerCarton <= 0 ||
          line.totalPieces <= 0) {
        return 'كمية الصنف ${line.itemName} غير صالحة.';
      }
    }

    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final businessDateOnly = DateTime(
      draft.businessDate.year,
      draft.businessDate.month,
      draft.businessDate.day,
    );
    if (businessDateOnly.isAfter(todayOnly)) {
      return 'لا يمكن تسجيل إذن $movementLabel بتاريخ مستقبلي.';
    }
    return null;
  }
}
