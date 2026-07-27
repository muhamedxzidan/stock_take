import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/returns/presentation/screens/warehouse_return_screen.dart';
import 'package:stock_take/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StockTakeApp());
    await tester.pumpAndSettle();
  });

  testWidgets('warehouse return UI renders without feature logic', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return const MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: WarehouseReturnScreen(),
            ),
          );
        },
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('تسجيل مرتجع للمخزن'), findsOneWidget);
    expect(find.text('واجهة تجريبية جاهزة للربط'), findsOneWidget);
    expect(find.text('حفظ مسودة المرتجع'), findsOneWidget);
  });
}
