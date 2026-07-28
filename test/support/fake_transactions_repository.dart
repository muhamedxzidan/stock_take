import 'dart:async';

import 'package:stock_take/features/transactions/data/models/inventory_movement.dart';
import 'package:stock_take/features/transactions/data/models/movement_record.dart';
import 'package:stock_take/features/transactions/data/models/transaction_model.dart';
import 'package:stock_take/features/transactions/data/repositories/transactions_repository_base.dart';
import 'package:stock_take/features/transactions/data/repositories/transactions_repository_failure.dart';

class FakeTransactionsRepository implements TransactionsRepositoryBase {
  late final StreamController<List<MovementRecord>> _movementController;
  final List<MovementRecord> _movements;
  final List<TransactionModel> _transactions = [];
  final List<InventoryMovementDraft> inboundDrafts = [];
  final List<InventoryMovementDraft> outboundDrafts = [];
  final Map<String, int> availableStockByItemId;
  int _nextInboundVoucherNumber = 1;
  int _nextOutboundVoucherNumber = 1;

  FakeTransactionsRepository({
    Map<String, int> availableStockByItemId = const <String, int>{},
    List<MovementRecord> movements = const [],
  }) : availableStockByItemId = Map.of(availableStockByItemId),
       _movements = [...movements] {
    _movementController = StreamController<List<MovementRecord>>.broadcast(
      onListen: () => _movementController.add(_visibleMovements),
    );
  }

  @override
  Stream<List<MovementRecord>> watchMovements() => _movementController.stream;

  @override
  Future<SavedInventoryMovement> createInboundMovement(
    InventoryMovementDraft draft,
  ) async {
    inboundDrafts.add(draft);
    final sequence = _nextInboundVoucherNumber++;
    final savedMovement = SavedInventoryMovement(
      movementId: 'movement-$sequence',
      voucherNumber:
          'IN-${draft.businessDate.year}-${sequence.toString().padLeft(6, '0')}',
    );
    _addMovementRecord(
      savedMovement: savedMovement,
      draft: draft,
      type: MovementRecordType.inbound,
    );
    return savedMovement;
  }

  @override
  Future<SavedInventoryMovement> createOutboundMovement(
    InventoryMovementDraft draft,
  ) async {
    for (final line in draft.lines) {
      final availableStock = availableStockByItemId[line.itemId];
      if (availableStock != null && line.totalPieces > availableStock) {
        throw TransactionsRepositoryFailure(
          'لا يمكن صرف ${line.itemName} (${line.itemCode}): '
          'المتاح $availableStock قطعة فقط.',
        );
      }
    }

    outboundDrafts.add(draft);
    final sequence = _nextOutboundVoucherNumber++;
    final savedMovement = SavedInventoryMovement(
      movementId: 'outbound-movement-$sequence',
      voucherNumber:
          'OUT-${draft.businessDate.year}-${sequence.toString().padLeft(6, '0')}',
    );
    _addMovementRecord(
      savedMovement: savedMovement,
      draft: draft,
      type: MovementRecordType.outbound,
    );
    return savedMovement;
  }

  @override
  Future<void> createTransaction(TransactionModel transaction) async {
    _transactions.insert(0, transaction);
  }

  @override
  Future<List<TransactionModel>> fetchTransactions() async {
    return List.unmodifiable(_transactions);
  }

  void _addMovementRecord({
    required SavedInventoryMovement savedMovement,
    required InventoryMovementDraft draft,
    required MovementRecordType type,
  }) {
    final sign = type == MovementRecordType.inbound ? 1 : -1;
    final lines = draft.lines
        .map(
          (line) => MovementRecordLine(
            itemId: line.itemId,
            itemCode: line.itemCode,
            itemName: line.itemName,
            unit: line.unit,
            itemsPerCarton: line.itemsPerCarton,
            cartons: line.cartons,
            pieces: line.pieces,
            totalPieces: line.totalPieces,
          ),
        )
        .toList(growable: false);
    _movements.insert(
      0,
      MovementRecord(
        id: savedMovement.movementId,
        voucherNumber: savedMovement.voucherNumber,
        type: type,
        businessAt: draft.businessDate,
        partyName: draft.partyName,
        deliveredBy: draft.deliveredBy,
        receivedBy: draft.receivedBy,
        driverName: draft.driverName,
        notes: draft.notes,
        lines: lines,
        itemDeltas: {
          for (final line in draft.lines) line.itemId: sign * line.totalPieces,
        },
      ),
    );
    _movementController.add(_visibleMovements);
  }

  List<MovementRecord> get _visibleMovements => List.unmodifiable(_movements);

  Future<void> close() => _movementController.close();
}
