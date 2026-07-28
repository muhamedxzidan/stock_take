import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/stocktake/cubit/stocktake_cubit.dart';
import 'package:stock_take/features/transactions/presentation/screens/stock_adjustment_screen.dart';

import '../../../support/fake_stocktake_repository.dart';

void main() {
  testWidgets('starts a session and saves an actual item count', (
    tester,
  ) async {
    final repository = FakeStocktakeRepository();
    final cubit = StocktakeCubit(repository);
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
    expect(find.text('رصيد النظام المثبّت: 120 قطعة'), findsOneWidget);

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

    expect(find.textContaining('تم حفظ S-N-1: 118 قطعة'), findsOneWidget);
    expect(find.text('تم عدّ 1 من 2'), findsOneWidget);
  });
}
