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
import 'package:stock_take/features/printing/cubit/printer_cubit.dart';
import 'package:stock_take/features/printing/presentation/widgets/thermal_receipt_content.dart';
import 'package:stock_take/features/returns/cubit/return_resolution_cubit.dart';
import 'package:stock_take/features/returns/cubit/returns_cubit.dart';
import 'package:stock_take/features/returns/data/models/return_resolution.dart';
import 'package:stock_take/features/returns/presentation/screens/warehouse_return_screen.dart';
import 'package:stock_take/features/transactions/cubit/transactions_cubit.dart';
import 'package:stock_take/features/transactions/presentation/screens/new_movement_screen.dart';
import 'package:stock_take/features/transactions/presentation/widgets/movement_type_selector.dart';
import 'package:stock_take/features/transactions/presentation/widgets/movement_ui_types.dart';
import 'package:stock_take/main.dart';

import 'support/fake_items_repository.dart';
import 'support/fake_printer_repository.dart';
import 'support/fake_returns_repository.dart';
import 'support/fake_stocktake_repository.dart';
import 'support/fake_transactions_repository.dart';

void main() {
  late FakeItemsRepository itemsRepository;
  late FakeReturnsRepository returnsRepository;
  late FakeStocktakeRepository stocktakeRepository;
  late FakeTransactionsRepository transactionsRepository;

  setUpAll(() async {
    itemsRepository = FakeItemsRepository();
    returnsRepository = FakeReturnsRepository();
    stocktakeRepository = FakeStocktakeRepository();
    transactionsRepository = FakeTransactionsRepository();
    await configureDependencies(
      authRepository: _AuthenticatedTestRepository(),
      itemsRepository: itemsRepository,
      returnsRepository: returnsRepository,
      stocktakeRepository: stocktakeRepository,
      transactionsRepository: transactionsRepository,
      reset: true,
    );
  });

  tearDownAll(() async {
    await serviceLocator.reset();
    await itemsRepository.close();
    await returnsRepository.close();
    await stocktakeRepository.close();
    await transactionsRepository.close();
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

  testWidgets('dashboard movement shortcuts use the canonical movement route', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const StockTakeApp());
    await tester.pumpAndSettle();

    serviceLocator<GoRouter>().go(AppRoutes.dashboard);
    await tester.pumpAndSettle();

    await tester.tap(find.text('منصرف جديد'));
    await tester.pumpAndSettle();

    expect(
      serviceLocator<GoRouter>().routeInformationProvider.value.uri.toString(),
      AppRoutes.newOutboundMovement,
    );
    expect(
      tester
          .widget<MovementTypeSelector>(find.byType(MovementTypeSelector))
          .selectedKind,
      MovementKind.outbound,
    );

    serviceLocator<GoRouter>().go(AppRoutes.dashboard);
    await tester.pumpAndSettle();
    await tester.tap(find.text('وارد جديد'));
    await tester.pumpAndSettle();

    expect(
      serviceLocator<GoRouter>().routeInformationProvider.value.uri.toString(),
      AppRoutes.newInboundMovement,
    );
    expect(
      tester
          .widget<MovementTypeSelector>(find.byType(MovementTypeSelector))
          .selectedKind,
      MovementKind.inbound,
    );
  });

  testWidgets(
    'stock balance printing includes all items even when search is active',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const StockTakeApp());
      await tester.pumpAndSettle();

      serviceLocator<GoRouter>().go(AppRoutes.dashboard);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'أرز');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('print-stock-balance')));
      await tester.pumpAndSettle();

      expect(find.text('كشف رصيد المخزن'), findsOneWidget);
      final receiptContent = find.byType(ThermalReceiptContent);
      expect(receiptContent, findsOneWidget);
      for (final item in sampleInventoryItems) {
        expect(
          find.descendant(
            of: receiptContent,
            matching: find.textContaining(item.name),
          ),
          findsOneWidget,
        );
      }
    },
  );

  testWidgets('warehouse return saves through its feature cubit', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<ItemCatalogCubit>(
                create: (_) => ItemCatalogCubit(itemsRepository)..loadItems(),
              ),
              BlocProvider<ReturnsCubit>(
                create: (_) => ReturnsCubit(returnsRepository),
              ),
              BlocProvider<ReturnResolutionCubit>(
                create: (_) => ReturnResolutionCubit(returnsRepository),
              ),
            ],
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
    expect(find.text('الحفظ متصل بالمخزون'), findsOneWidget);
    expect(find.text('حفظ المرتجع وإضافته للمخزون'), findsOneWidget);
    expect(find.byKey(const Key('inventory-item-selector')), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const Key('inventory-item-selector')),
    );
    await tester.tap(find.byKey(const Key('inventory-item-selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('inventory-item-option-1')));
    await tester.pumpAndSettle();
    expect(find.text('كود الصنف: ITM-001'), findsOneWidget);
    expect(
      find.byKey(const Key('return-original-voucher-field')),
      findsNothing,
    );
    expect(find.byKey(const Key('return-returned-by-field')), findsNothing);
    expect(find.byKey(const Key('return-received-by-field')), findsNothing);
    expect(find.byKey(const Key('return-reason-field')), findsNothing);
    await tester.enterText(
      find.byKey(const Key('return-quantity-cartons-field')),
      '١',
    );
    await tester.pump();

    expect(
      find.text(
        'الكمية: 1 كرتونة • الإجمالي المكافئ: 12 قطعة'
        ' • الكرتونة = 12 قطعة',
      ),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const Key('return-source-field')),
      'فرع مدينة نصر',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('save-customer-return')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('save-customer-return')),
        matching: find.byType(ElevatedButton),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('تم حفظ المرتجع RET-'), findsOneWidget);
    expect(returnsRepository.drafts.last.quantityPieces, 12);

    expect(find.byKey(const Key('pending-return-return-1')), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(const Key('replace-return-return-1')),
    );
    await tester.tap(find.byKey(const Key('replace-return-return-1')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('return-resolution-supplier-field')),
      'المورد الرئيسي',
    );
    await tester.tap(find.byKey(const Key('confirm-return-resolution')));
    await tester.pumpAndSettle();

    expect(
      returnsRepository.resolutions.last.kind,
      ReturnResolutionKind.replaced,
    );
    expect(find.byKey(const Key('pending-return-return-1')), findsNothing);
  });

  testWidgets('new movement UI adds items without leaving the mobile screen', (
    WidgetTester tester,
  ) async {
    await _pumpMovementScreen(tester, size: const Size(390, 844));

    expect(find.text('حركة جديدة'), findsOneWidget);
    expect(find.text('وارد +'), findsOneWidget);
    expect(find.text('منصرف −'), findsOneWidget);
    expect(find.byKey(const Key('add-new-item-from-movement')), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('movement-item-1')));
    await tester.tapAt(
      tester.getTopLeft(find.byKey(const Key('movement-item-1'))) +
          const Offset(24, 24),
    );
    await tester.pumpAndSettle();

    expect(find.text('الكراتين (الأساسي)'), findsOneWidget);
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
      find.text('عند التأكيد سيُحفظ إذن الوارد وتُحدّث الأرصدة معًا.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('voucher-ui-finish')));
    await tester.pumpAndSettle();

    expect(find.textContaining('تم حفظ إذن الوارد IN-'), findsOneWidget);
    expect(find.textContaining('طباعة IN-'), findsOneWidget);
    expect(find.byKey(const Key('receipt-select-printer')), findsOneWidget);
    expect(find.text('الإذن الحالي: فارغ'), findsOneWidget);
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
  final transactionsRepository = FakeTransactionsRepository();
  addTearDown(itemsRepository.close);
  addTearDown(transactionsRepository.close);
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
        return MultiBlocProvider(
          providers: [
            BlocProvider<ItemCatalogCubit>(
              create: (context) =>
                  ItemCatalogCubit(itemsRepository)..loadItems(),
            ),
            BlocProvider<TransactionsCubit>(
              create: (context) => TransactionsCubit(transactionsRepository),
            ),
            BlocProvider<PrinterCubit>(
              create: (context) =>
                  PrinterCubit(FakePrinterRepository())..initialize(),
            ),
          ],
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
