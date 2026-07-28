import 'dart:async';

import 'package:stock_take/features/stocktake/data/models/stocktake_line.dart';
import 'package:stock_take/features/stocktake/data/models/stocktake_session.dart';
import 'package:stock_take/features/stocktake/data/repositories/stocktake_repository_base.dart';
import 'package:stock_take/features/stocktake/data/repositories/stocktake_repository_failure.dart';

class FakeStocktakeRepository implements StocktakeRepositoryBase {
  late final StreamController<List<StocktakeLine>> _linesController;
  StocktakeSession? _openSession;
  List<StocktakeLine> _lines;
  int _nextNumber = 1;
  int completeCalls = 0;

  FakeStocktakeRepository({
    StocktakeSession? openSession,
    List<StocktakeLine> lines = const [],
  }) : _openSession = openSession,
       _lines = [...lines] {
    _linesController = StreamController<List<StocktakeLine>>.broadcast(
      onListen: () => _linesController.add(List.unmodifiable(_lines)),
    );
  }

  @override
  Future<StocktakeSession?> fetchOpenStocktake() async => _openSession;

  @override
  Stream<List<StocktakeLine>> watchLines(String stocktakeId) =>
      _linesController.stream;

  @override
  Future<StocktakeSession> startStocktake(StartStocktakeDraft draft) async {
    if (_openSession != null) {
      throw const StocktakeRepositoryFailure('توجد جلسة جرد مفتوحة بالفعل.');
    }
    final sequence = _nextNumber++;
    _openSession = StocktakeSession(
      id: 'stocktake-$sequence',
      stocktakeNumber:
          'STK-${draft.periodTo.year}-${sequence.toString().padLeft(6, '0')}',
      status: StocktakeStatus.open,
      periodFrom: draft.periodFrom,
      periodTo: draft.periodTo,
      startedAt: DateTime.now(),
      completedAt: null,
      notes: draft.notes,
    );
    _lines = [...sampleStocktakeLines];
    _linesController.add(List.unmodifiable(_lines));
    return _openSession!;
  }

  @override
  Future<void> saveCount({
    required String stocktakeId,
    required String itemId,
    required int actualQuantityPieces,
  }) async {
    if (_openSession?.id != stocktakeId) {
      throw const StocktakeRepositoryFailure('جلسة الجرد لم تعد مفتوحة.');
    }
    final index = _lines.indexWhere((line) => line.itemId == itemId);
    if (index == -1) {
      throw const StocktakeRepositoryFailure(
        'الصنف غير موجود داخل جلسة الجرد.',
      );
    }
    final line = _lines[index];
    _lines[index] = line.copyWith(
      actualQuantityPieces: actualQuantityPieces,
      differencePieces: actualQuantityPieces - line.systemQuantityPieces,
      counted: true,
      countedAt: DateTime.now(),
    );
    _linesController.add(List.unmodifiable(_lines));
  }

  @override
  Future<SavedStocktakeCompletion> completeStocktake(String stocktakeId) async {
    final session = _openSession;
    if (session == null || session.id != stocktakeId) {
      throw const StocktakeRepositoryFailure('تم اعتماد جلسة الجرد من قبل.');
    }
    if (_lines.any((line) => !line.counted)) {
      throw const StocktakeRepositoryFailure(
        'يجب حفظ العدد الفعلي لكل الأصناف قبل اعتماد الجرد.',
      );
    }

    completeCalls += 1;
    final adjustedLines = _lines
        .where((line) => line.differencePieces != 0)
        .toList(growable: false);
    _openSession = null;
    return SavedStocktakeCompletion(
      stocktakeNumber: session.stocktakeNumber,
      movementVoucherNumber: adjustedLines.isEmpty
          ? null
          : 'ADJ-${session.periodTo.year}-000001',
      adjustedItemCount: adjustedLines.length,
      netDifferencePieces: adjustedLines.fold(
        0,
        (total, line) => total + line.differencePieces,
      ),
    );
  }

  Future<void> close() => _linesController.close();
}

const sampleStocktakeLines = <StocktakeLine>[
  StocktakeLine(
    itemId: '1',
    itemNameSnapshot: 'زيت دوار الشمس',
    itemCodeSnapshot: 'S-N-1',
    unit: 'piece',
    itemsPerCarton: 12,
    systemQuantityPieces: 120,
    actualQuantityPieces: 0,
    differencePieces: -120,
    counted: false,
    countedAt: null,
  ),
  StocktakeLine(
    itemId: '2',
    itemNameSnapshot: 'أرز مصري',
    itemCodeSnapshot: 'S-N-2',
    unit: 'piece',
    itemsPerCarton: 10,
    systemQuantityPieces: 80,
    actualQuantityPieces: 0,
    differencePieces: -80,
    counted: false,
    countedAt: null,
  ),
];
