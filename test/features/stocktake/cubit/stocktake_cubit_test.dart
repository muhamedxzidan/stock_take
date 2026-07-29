import 'dart:async';

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

  test('cancels an open session without completing or adjusting it', () async {
    await cubit.startStocktake(
      StartStocktakeDraft(
        periodFrom: DateTime(2026, 7, 28),
        periodTo: DateTime(2026, 7, 28),
        notes: '',
      ),
    );
    await Future<void>.delayed(Duration.zero);

    final cancelled = await cubit.cancelStocktake();

    expect(cancelled, isTrue);
    expect(repository.cancelCalls, 1);
    expect(repository.completeCalls, 0);
    expect(cubit.state, isA<StocktakeCancelled>());
    expect((cubit.state as StocktakeCancelled).session, isNull);

    await cubit.load();
    expect((cubit.state as StocktakeReady).session, isNull);
  });

  test('times out a hanging load and succeeds on retry', () async {
    await cubit.close();
    await repository.close();
    final hangingLoad = Completer<StocktakeSession?>();
    repository = FakeStocktakeRepository(
      onFetchOpenStocktake: (call) =>
          call == 1 ? hangingLoad.future : Future.value(null),
    );
    cubit = StocktakeCubit(
      repository,
      loadTimeout: const Duration(milliseconds: 10),
    );

    await cubit.load();
    expect(cubit.state, isA<StocktakeFailure>());
    expect((cubit.state as StocktakeFailure).message, contains('وقتًا أطول'));

    await cubit.load();
    expect(cubit.state, isA<StocktakeReady>());
    expect((cubit.state as StocktakeReady).session, isNull);
    expect(repository.fetchCalls, 2);
  });

  test('ignores an older load response after a newer retry', () async {
    await cubit.close();
    await repository.close();
    final oldLoad = Completer<StocktakeSession?>();
    repository = FakeStocktakeRepository(
      onFetchOpenStocktake: (call) =>
          call == 1 ? oldLoad.future : Future.value(null),
    );
    cubit = StocktakeCubit(repository);

    final firstLoad = cubit.load();
    await Future<void>.delayed(Duration.zero);
    await cubit.load();
    oldLoad.complete(_openSession());
    await firstLoad;

    expect((cubit.state as StocktakeReady).session, isNull);
    expect(repository.fetchCalls, 2);
  });

  test('times out when open-session lines never produce a snapshot', () async {
    await cubit.close();
    await repository.close();
    repository = FakeStocktakeRepository(
      openSession: _openSession(),
      emitInitialLinesOnListen: false,
    );
    cubit = StocktakeCubit(
      repository,
      loadTimeout: const Duration(milliseconds: 10),
    );

    await cubit.load();

    expect(cubit.state, isA<StocktakeFailure>());
    expect(repository.activeLineListeners, 0);
  });
}

StocktakeSession _openSession() => StocktakeSession(
  id: 'open-stocktake',
  stocktakeNumber: 'STK-2026-000099',
  status: StocktakeStatus.open,
  periodFrom: DateTime(2026, 7, 28),
  periodTo: DateTime(2026, 7, 28),
  startedAt: DateTime(2026, 7, 28, 10),
  completedAt: null,
  notes: '',
);
