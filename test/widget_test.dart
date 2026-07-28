import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_take/core/constants/app_routes.dart';
import 'package:stock_take/core/di/service_locator.dart';
import 'package:stock_take/core/theme/app_theme.dart';
import 'package:stock_take/features/auth/data/repositories/auth_repository.dart';
import 'package:stock_take/features/items/cubit/item_catalog_cubit.dart';
import 'package:stock_take/features/returns/presentation/screens/warehouse_return_screen.dart';
import 'package:stock_take/features/transactions/presentation/screens/new_movement_screen.dart';
import 'package:stock_take/main.dart';

import 'support/fake_items_repository.dart';

void main() {
  late FakeItemsRepository itemsRepository;

  setUpAll(() async {
    itemsRepository = FakeItemsRepository();
    await configureDependencies(
      authRepository: _AuthenticatedTestRepository(),
      itemsRepository: itemsRepository,
      reset: true,
    );
  });

  tearDownAll(() async {
    await serviceLocator.reset();
    await itemsRepository.close();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StockTakeApp());
    await tester.pumpAndSettle();
  });

  testWidgets('worker shell exposes only the three mobile destinations', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const StockTakeApp());
    await tester.pumpAndSettle();

    expect(find.text('حركة جديدة'), findsAtLeastNWidgets(1));
    expect(find.text('رصيد المخزن'), findsOneWidget);
    expect(find.text('سجل الحركات'), findsOneWidget);
    expect(find.text('تسجيل وارد'), findsNothing);
    expect(find.text('تسجيل منصرف'), findsNothing);
    expect(find.byKey(const Key('open-warehouse-return')), findsOneWidget);
    expect(find.byKey(const Key('open-stocktake')), findsOneWidget);
  });

  testWidgets('warehouse return opens and returns to the new movement', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const StockTakeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('open-warehouse-return')));
    await tester.pumpAndSettle();
    expect(find.text('تسجيل مرتجع للمخزن'), findsOneWidget);

    await tester.tap(find.byKey(const Key('return-to-new-movement')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('open-stocktake')), findsOneWidget);
  });

  testWidgets('stocktake opens and returns to the new movement', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const StockTakeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('open-stocktake')));
    await tester.pumpAndSettle();
    expect(
      serviceLocator<GoRouter>().routeInformationProvider.value.uri.path,
      AppRoutes.stockAdjustment,
    );
    expect(find.byKey(const Key('stocktake-to-new-movement')), findsOneWidget);

    await tester.tap(find.byKey(const Key('stocktake-to-new-movement')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('open-warehouse-return')), findsOneWidget);
  });

  testWidgets('warehouse return UI renders without feature logic', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return BlocProvider<ItemCatalogCubit>(
            create: (_) => ItemCatalogCubit(itemsRepository)..loadItems(),
            child: const MaterialApp(
              home: Directionality(
                textDirection: TextDirection.rtl,
                child: WarehouseReturnScreen(),
              ),
            ),
          );
        },
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('تسجيل مرتجع للمخزن'), findsOneWidget);
    expect(find.text('واجهة تجريبية جاهزة للربط'), findsOneWidget);
    expect(find.text('حفظ مسودة المرتجع'), findsOneWidget);
    expect(find.byKey(const Key('inventory-item-selector')), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const Key('inventory-item-selector')),
    );
    await tester.tap(find.byKey(const Key('inventory-item-selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('inventory-item-option-1')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('return-quantity-cartons-field')),
      '١',
    );
    await tester.pump();

    expect(find.text('الإجمالي: 12 قطعة • الكرتونة = 12 قطعة'), findsOneWidget);
  });

  testWidgets('new movement UI adds items without leaving the mobile screen', (
    WidgetTester tester,
  ) async {
    await _pumpMovementScreen(tester, size: const Size(390, 844));

    expect(find.text('حركة جديدة'), findsOneWidget);
    expect(find.text('وارد +'), findsOneWidget);
    expect(find.text('منصرف −'), findsOneWidget);

    await tester.tap(find.byKey(const Key('movement-item-1')));
    await tester.pumpAndSettle();

    expect(find.text('عدد الكراتين'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('item-quantity-cartons-field')),
      '١',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('item-quantity-add')));
    await tester.pumpAndSettle();

    expect(find.text('الإذن الحالي: صنف واحد'), findsOneWidget);

    await tester.tap(find.byKey(const Key('mobile-voucher-summary')));
    await tester.pumpAndSettle();

    expect(find.text('استكمال ومراجعة الإذن'), findsOneWidget);

    await tester.tap(find.byKey(const Key('voucher-continue')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'شركة النيل');
    await tester.tap(find.byKey(const Key('movement-details-preview')));
    await tester.pumpAndSettle();

    expect(find.text('معاينة إذن وارد'), findsOneWidget);
    expect(
      find.text('هذه معاينة UI فقط؛ لن يتم حفظ البيانات أو تعديل الرصيد.'),
      findsOneWidget,
    );
  });

  testWidgets('new movement UI shows a persistent voucher on desktop', (
    WidgetTester tester,
  ) async {
    await _pumpMovementScreen(tester, size: const Size(1280, 900));

    expect(find.text('الإذن الحالي'), findsOneWidget);
    expect(find.byKey(const Key('mobile-voucher-summary')), findsNothing);

    await tester.tap(find.byKey(const Key('movement-item-1')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('item-quantity-cartons-field')),
      '1',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('item-quantity-add')));
    await tester.pumpAndSettle();

    final continueButton = tester.widget<FilledButton>(
      find.byKey(const Key('voucher-continue')),
    );
    expect(continueButton.onPressed, isNotNull);
  });
}

class _AuthenticatedTestRepository implements AuthRepository {
  @override
  bool get isSignedIn => true;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signOut() async {}

  @override
  Stream<bool> watchAuthentication() => const Stream<bool>.empty();
}

Future<void> _pumpMovementScreen(
  WidgetTester tester, {
  required Size size,
}) async {
  final itemsRepository = FakeItemsRepository();
  addTearDown(itemsRepository.close);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider<ItemCatalogCubit>(
          create: (context) => ItemCatalogCubit(itemsRepository)..loadItems(),
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Directionality(
              textDirection: TextDirection.rtl,
              child: NewMovementScreen(),
            ),
          ),
        );
      },
    ),
  );

  await tester.pump(const Duration(milliseconds: 350));
  await tester.pumpAndSettle();
}
