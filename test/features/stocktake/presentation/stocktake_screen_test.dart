import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_take/features/stocktake/data/models/stocktake_session.dart';
import 'package:stock_take/features/stocktake/cubit/stocktake_cubit.dart';
import 'package:stock_take/features/transactions/presentation/screens/stock_adjustment_screen.dart';

import '../../../support/fake_stocktake_repository.dart';

void main() {
  testWidgets('starts a session and saves an actual item count', (
    tester,
  ) async {
    final repository = FakeStocktakeRepository();
    final cubit = StocktakeCubit(repository)..load();
    addTearDown(() async {
      await cubit.close();
      await repository.close();
    });

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => BlocProvider.value(
          value: cubit,
          child: const MaterialApp(home: StockAdjustmentScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('start-stocktake')), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('start-stocktake')),
        matching: find.byType(ElevatedButton),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('STK-2026-000001'), findsOneWidget);
    expect(find.byKey(const Key('stocktake-line-1')), findsOneWidget);
    expect(
      find.text('رصيد النظام المثبّت: 10 كرتونة • 120 قطعة إجمالي'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const Key('stocktake-1-cartons-field')),
      '٩',
    );
    await tester.enterText(
      find.byKey(const Key('stocktake-1-pieces-field')),
      '١٠',
    );
    tester.testTextInput.hide();
    await tester.pump();
    await tester.drag(
      find.byKey(const Key('stocktake-lines-list')),
      const Offset(0, -260),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('save-stocktake-line-1')),
        matching: find.byType(ElevatedButton),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('تم حفظ S-N-1: 9 كرتونة + 10 قطعة • 118 قطعة إجمالي'),
      findsOneWidget,
    );
    expect(find.text('تم عدّ 1 من 2'), findsOneWidget);
  });

  testWidgets(
    'leaving during a delayed load and returning creates a fresh route cubit',
    (tester) async {
      final delayedFirstLoad = Completer<StocktakeSession?>();
      final session = StocktakeSession(
        id: 'open-stocktake',
        stocktakeNumber: 'STK-2026-000099',
        status: StocktakeStatus.open,
        periodFrom: DateTime(2026, 7, 28),
        periodTo: DateTime(2026, 7, 28),
        startedAt: DateTime(2026, 7, 28, 10),
        completedAt: null,
        notes: '',
      );
      final repository = FakeStocktakeRepository(
        openSession: session,
        lines: sampleStocktakeLines,
        onFetchOpenStocktake: (call) =>
            call == 1 ? delayedFirstLoad.future : Future.value(session),
      );
      final router = GoRouter(
        initialLocation: '/stocktake',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(body: Text('الرئيسية')),
          ),
          GoRoute(
            path: '/stocktake',
            builder: (_, _) => BlocProvider(
              create: (_) => StocktakeCubit(repository)..load(),
              child: const StockAdjustmentScreen(),
            ),
          ),
        ],
      );
      addTearDown(() async {
        router.dispose();
        await repository.close();
      });

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      router.go('/');
      await tester.pumpAndSettle();
      expect(find.text('الرئيسية'), findsOneWidget);

      router.go('/stocktake');
      await tester.pumpAndSettle();
      expect(find.text('STK-2026-000099'), findsOneWidget);
      expect(repository.fetchCalls, 2);
      expect(repository.activeLineListeners, 1);

      delayedFirstLoad.complete(session);
      await tester.pump();
      router.go('/');
      await tester.pumpAndSettle();
      expect(repository.activeLineListeners, 0);
    },
  );
}
