import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/printing/cubit/printer_cubit.dart';
import 'package:stock_take/features/printing/data/models/printer_connection_profile.dart';
import 'package:stock_take/features/printing/data/models/printer_discovery_snapshot.dart';
import 'package:stock_take/features/printing/data/models/saved_printer.dart';
import 'package:stock_take/features/printing/presentation/widgets/printer_setup_button.dart';

import '../../../support/fake_printer_repository.dart';

void main() {
  testWidgets('searches, connects and remembers the selected printer', (
    tester,
  ) async {
    const printer = SavedPrinter(
      address: '00:11:22:33:44:55',
      name: 'XP-P802A',
    );
    final repository = FakePrinterRepository();
    final cubit = PrinterCubit(repository);
    await cubit.initialize();
    addTearDown(() async {
      await cubit.close();
      await repository.close();
    });

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => BlocProvider.value(
          value: cubit,
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(actions: const [PrinterSetupButton()]),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('printer-setup-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    repository.emitDiscovery(
      const PrinterDiscoverySnapshot(
        availability: PrinterDiscoveryAvailability.ready,
        devices: [printer],
      ),
    );
    await tester.pump();

    expect(find.text('XP-P802A'), findsOneWidget);
    expect(find.text('00:11:22:33:44:55'), findsOneWidget);

    await tester.tap(find.byKey(const Key('printer-device-00:11:22:33:44:55')));
    await tester.pumpAndSettle();

    expect(repository.connectCalls, 1);
    expect(repository.saveCalls, 1);
    expect(cubit.state.selectedPrinter, printer);
    expect(find.text('اختيار طابعة البلوتوث'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Web Bluetooth waits for a direct Chrome button tap before discovery',
    (tester) async {
      final repository = FakePrinterRepository(
        connectionProfile: PrinterConnectionProfile.webBluetooth,
      );
      final cubit = PrinterCubit(repository);
      await cubit.initialize();
      addTearDown(() async {
        await cubit.close();
        await repository.close();
      });

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => BlocProvider.value(
            value: cubit,
            child: MaterialApp(
              home: Scaffold(
                appBar: AppBar(actions: const [PrinterSetupButton()]),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('printer-setup-button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(repository.discoveryCalls, 0);
      expect(find.text('تجربة الطابعة من Chrome'), findsOneWidget);
      expect(find.text('بدء البحث من Chrome'), findsOneWidget);

      await tester.tap(find.byKey(const Key('printer-start-discovery-button')));
      await tester.pump();

      expect(repository.discoveryCalls, 1);
      expect(cubit.state.availability, PrinterDiscoveryAvailability.searching);
      expect(tester.takeException(), isNull);
    },
  );
}
