import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/stocktake/cubit/stocktake_cubit.dart';
import 'package:stock_take/features/stocktake/cubit/stocktake_state.dart';
import 'package:stock_take/features/stocktake/data/models/stocktake_session.dart';

import '../../../support/fake_stocktake_repository.dart';

void main() {
  late FakeStocktakeRepository repository;
  late StocktakeCubit cubit;

  setUp(() {
    repository = FakeStocktakeRepository();
    cubit = StocktakeCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await repository.close();
  });

  test('starts a session and restores saved count progress', () async {
    await cubit.load();
    expect((cubit.state as StocktakeReady).session, isNull);

    final started = await cubit.startStocktake(
      StartStocktakeDraft(
        periodFrom: DateTime(2026, 7, 28),
        periodTo: DateTime(2026, 7, 28),
        notes: 'جرد يومي',
      ),
    );
    expect(started, isTrue);
    await Future<void>.delayed(Duration.zero);

    final session = (cubit.state as StocktakeReady).session;
    expect(session?.stocktakeNumber, 'STK-2026-000001');

    final saved = await cubit.saveCount(itemId: '1', actualQuantityPieces: 118);
    expect(saved, isTrue);
    expect(
      (cubit.state as StocktakeReady).lines
          .firstWhere((line) => line.itemId == '1')
          .differencePieces,
      -2,
    );

    await cubit.close();
    cubit = StocktakeCubit(repository);
    await cubit.load();
    await Future<void>.delayed(Duration.zero);

    final restoredLine = (cubit.state as StocktakeReady).lines.firstWhere(
      (line) => line.itemId == '1',
    );
    expect(restoredLine.counted, isTrue);
    expect(restoredLine.actualQuantityPieces, 118);
  });

  test('requires every count and completes the same session once', () async {
    await cubit.startStocktake(
      StartStocktakeDraft(
        periodFrom: DateTime(2026, 7, 28),
        periodTo: DateTime(2026, 7, 28),
        notes: '',
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(await cubit.completeStocktake(), isNull);
    expect((cubit.state as StocktakeFailure).message, contains('كل الأصناف'));

    expect(
      await cubit.saveCount(itemId: '1', actualQuantityPieces: 118),
      isTrue,
    );
    expect(
      await cubit.saveCount(itemId: '2', actualQuantityPieces: 82),
      isTrue,
    );

    final completion = await cubit.completeStocktake();
    expect(completion?.adjustedItemCount, 2);
    expect(completion?.netDifferencePieces, 0);
    expect(repository.completeCalls, 1);
    expect(cubit.state, isA<StocktakeCompleted>());

    expect(await cubit.completeStocktake(), isNull);
    expect(repository.completeCalls, 1);
  });
}
