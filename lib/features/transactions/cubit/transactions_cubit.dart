import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/inventory_movement.dart';
import '../data/models/transaction_model.dart';
import '../data/repositories/transactions_repository_base.dart';
import '../data/repositories/transactions_repository_failure.dart';
import 'transactions_state.dart';

/// TransactionsCubit manages transaction submission and log filtering.
class TransactionsCubit extends Cubit<TransactionsState> {
  final TransactionsRepositoryBase _repository;
  Timer? _debounceTimer;
  List<TransactionModel> _allLogs = [];
  TransactionType? _currentFilter;
  bool _isSavingMovement = false;

  TransactionsCubit(this._repository) : super(TransactionsInitial());

  Future<SavedInventoryMovement?> createInboundMovement(
    InventoryMovementDraft draft,
  ) {
    return _saveMovement(draft: draft, isInbound: true);
  }

  Future<SavedInventoryMovement?> createOutboundMovement(
    InventoryMovementDraft draft,
  ) {
    return _saveMovement(draft: draft, isInbound: false);
  }

  Future<SavedInventoryMovement?> _saveMovement({
    required InventoryMovementDraft draft,
    required bool isInbound,
  }) async {
    if (_isSavingMovement) {
      return null;
    }

    final validationMessage = _validateMovementDraft(
      draft,
      isInbound: isInbound,
    );
    if (validationMessage != null) {
      emit(InventoryMovementFailure(validationMessage));
      return null;
    }

    _isSavingMovement = true;
    emit(InventoryMovementSaving());
    try {
      final movement = isInbound
          ? await _repository.createInboundMovement(draft)
          : await _repository.createOutboundMovement(draft);
      emit(InventoryMovementSaved(movement));
      return movement;
    } on TransactionsRepositoryFailure catch (failure) {
      emit(InventoryMovementFailure(failure.message));
      return null;
    } catch (_) {
      emit(
        InventoryMovementFailure(
          'تعذر حفظ إذن ${isInbound ? 'الوارد' : 'المنصرف'} الآن.',
        ),
      );
      return null;
    } finally {
      _isSavingMovement = false;
    }
  }

  String? _validateMovementDraft(
    InventoryMovementDraft draft, {
    required bool isInbound,
  }) {
    final movementLabel = isInbound ? 'الوارد' : 'المنصرف';
    if (draft.lines.isEmpty) {
      return 'أضف صنفًا واحدًا على الأقل إلى إذن $movementLabel.';
    }
    if (draft.lines.length > 50) {
      return 'الحد الأقصى للإذن الواحد هو 50 صنفًا.';
    }
    if (draft.partyName.trim().isEmpty || draft.partyName.length > 200) {
      return isInbound
          ? 'اكتب اسم المورد بشكل صحيح.'
          : 'اكتب اسم الجهة المستلمة بشكل صحيح.';
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

  /// Loads full list of inventory transactions.
  Future<void> loadTransactions() async {
    emit(TransactionsLoading());
    try {
      _allLogs = await _repository.fetchTransactions();
      emit(
        TransactionsSuccess(
          transactions: _allLogs,
          selectedFilter: _currentFilter,
        ),
      );
    } catch (e) {
      emit(TransactionsFailure('فشل في تحميل سجل الحركات.'));
    }
  }

  /// Filters logs by transaction type (Inbound / Outbound / Adjustment / All).
  void filterByType(TransactionType? type) {
    _currentFilter = type;
    _applyFilterAndQuery(query: '');
  }

  /// Search logs with 300ms debounce.
  void onSearchQueryChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _applyFilterAndQuery(query: query);
    });
  }

  void _applyFilterAndQuery({required String query}) {
    List<TransactionModel> result = List.from(_allLogs);

    if (_currentFilter != null) {
      result = result.where((log) => log.type == _currentFilter).toList();
    }

    final trimmed = query.trim().toLowerCase();
    if (trimmed.isNotEmpty) {
      result = result.where((log) {
        return log.itemName.toLowerCase().contains(trimmed) ||
            log.itemCode.toLowerCase().contains(trimmed) ||
            log.partyName.toLowerCase().contains(trimmed) ||
            log.voucherNumber.toLowerCase().contains(trimmed);
      }).toList();
    }

    emit(
      TransactionsSuccess(transactions: result, selectedFilter: _currentFilter),
    );
  }

  /// Record an Inbound transaction.
  Future<void> createInboundTransaction({
    required String itemName,
    required String itemCode,
    required int quantity,
    required String supplierName,
    required String deliveredBy,
    required String receivedBy,
    required String date,
  }) async {
    emit(TransactionsLoading());
    try {
      final log = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        voucherNumber: 'INV-${DateTime.now().millisecond}',
        type: TransactionType.inbound,
        itemId: '1',
        itemName: itemName,
        itemCode: itemCode,
        quantity: quantity,
        unit: 'قطعة',
        partyName: supplierName,
        actorName: deliveredBy,
        receiverName: receivedBy,
        date: date,
        notes: 'إذن وارد مخزني جديد',
      );

      await _repository.createTransaction(log);
      await loadTransactions();
    } catch (e) {
      emit(TransactionsFailure('فشل في تسجيل الوارد.'));
    }
  }

  /// Record an Outbound transaction.
  Future<void> createOutboundTransaction({
    required String itemName,
    required String itemCode,
    required int quantity,
    required String recipientEntity,
    required String dispatchedBy,
    required String receivedBy,
    required String date,
  }) async {
    emit(TransactionsLoading());
    try {
      final log = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        voucherNumber: 'OUT-${DateTime.now().millisecond}',
        type: TransactionType.outbound,
        itemId: '1',
        itemName: itemName,
        itemCode: itemCode,
        quantity: quantity,
        unit: 'قطعة',
        partyName: recipientEntity,
        actorName: dispatchedBy,
        receiverName: receivedBy,
        date: date,
        notes: 'إذن منصرف مخزني جديد',
      );

      await _repository.createTransaction(log);
      await loadTransactions();
    } catch (e) {
      emit(TransactionsFailure('فشل في تسجيل المنصرف.'));
    }
  }

  /// Record a Stock Adjustment transaction.
  Future<void> createAdjustmentTransaction({
    required String itemName,
    required String itemCode,
    required int diffQuantity,
    required String reason,
    required String date,
  }) async {
    emit(TransactionsLoading());
    try {
      final log = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        voucherNumber: 'ADJ-${DateTime.now().millisecond}',
        type: TransactionType.adjustment,
        itemId: '1',
        itemName: itemName,
        itemCode: itemCode,
        quantity: diffQuantity,
        unit: 'قطعة',
        partyName: 'تسوية جردية',
        actorName: 'أمين المخزن',
        receiverName: 'أمين المخزن',
        date: date,
        notes: reason,
      );

      await _repository.createTransaction(log);
      await loadTransactions();
    } catch (e) {
      emit(TransactionsFailure('فشل في تسجيل التسوية الجردية.'));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
