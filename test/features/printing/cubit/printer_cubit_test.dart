import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/printing/cubit/printer_cubit.dart';
import 'package:stock_take/features/printing/data/models/saved_printer.dart';

import '../../../support/fake_printer_repository.dart';

void main() {
  const printer = SavedPrinter(
    address: '00:11:22:33:44:55',
    name: 'print001-57bb',
  );

  test('loads the saved printer without reconnecting on startup', () async {
    final repository = FakePrinterRepository(selectedPrinter: printer);
    final cubit = PrinterCubit(repository);
    addTearDown(() async {
      await cubit.close();
      await repository.close();
    });

    await cubit.initialize();

    expect(cubit.state.selectedPrinter, printer);
    expect(repository.connectCalls, 0);
  });

  test('connects first then persists the selected printer', () async {
    final repository = FakePrinterRepository();
    final cubit = PrinterCubit(repository);
    addTearDown(() async {
      await cubit.close();
      await repository.close();
    });

    final selected = await cubit.selectAndConnect(printer);

    expect(selected, isTrue);
    expect(repository.connectCalls, 1);
    expect(repository.saveCalls, 1);
    expect(repository.selectedPrinter, printer);
    expect(cubit.state.selectedPrinter, printer);
  });

  test('guards repeated connection taps while one is pending', () async {
    final connection = Completer<bool>();
    final repository = FakePrinterRepository(
      pendingConnection: connection.future,
    );
    final cubit = PrinterCubit(repository);
    addTearDown(() async {
      await cubit.close();
      await repository.close();
    });

    final firstSelection = cubit.selectAndConnect(printer);
    await Future<void>.delayed(Duration.zero);
    final repeatedSelection = await cubit.selectAndConnect(printer);
    connection.complete(true);

    expect(repeatedSelection, isFalse);
    expect(await firstSelection, isTrue);
    expect(repository.connectCalls, 1);
    expect(repository.saveCalls, 1);
  });

  test(
    'guards repeated printing taps and keeps stock outside the flow',
    () async {
      final print = Completer<bool>();
      final repository = FakePrinterRepository(
        selectedPrinter: printer,
        pendingPrint: print.future,
      );
      final cubit = PrinterCubit(repository);
      final imageBytes = _fakeReceiptPng();
      addTearDown(() async {
        await cubit.close();
        await repository.close();
      });
      await cubit.initialize();

      final firstPrint = cubit.printReceipt(imageBytes);
      await Future<void>.delayed(Duration.zero);
      final repeatedPrint = await cubit.printReceipt(imageBytes);
      print.complete(true);

      expect(repeatedPrint, isFalse);
      expect(await firstPrint, isTrue);
      expect(repository.printCalls, 1);
      expect(cubit.state.isPrinting, isFalse);
    },
  );

  test(
    'Android print failure keeps the saved movement outside the flow',
    () async {
      final repository = FakePrinterRepository(
        selectedPrinter: printer,
        printResult: false,
      );
      final cubit = PrinterCubit(repository);
      addTearDown(() async {
        await cubit.close();
        await repository.close();
      });
      await cubit.initialize();

      final printed = await cubit.printReceipt(_fakeReceiptPng());

      expect(printed, isFalse);
      expect(repository.printCalls, 1);
      expect(cubit.state.message, contains('print001-57bb'));
      expect(cubit.state.message, contains('قريبة'));
    },
  );
}

Uint8List _fakeReceiptPng() => Uint8List.fromList(const [137, 80, 78, 71]);
