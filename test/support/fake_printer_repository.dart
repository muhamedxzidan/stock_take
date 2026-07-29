import 'dart:async';
import 'dart:typed_data';

import 'package:stock_take/features/printing/data/models/printer_connection_profile.dart';
import 'package:stock_take/features/printing/data/models/printer_discovery_snapshot.dart';
import 'package:stock_take/features/printing/data/models/saved_printer.dart';
import 'package:stock_take/features/printing/data/repositories/printer_repository_base.dart';

class FakePrinterRepository implements PrinterRepositoryBase {
  final StreamController<PrinterDiscoverySnapshot> _discoveryController =
      StreamController<PrinterDiscoverySnapshot>.broadcast();

  SavedPrinter? selectedPrinter;
  bool connectResult;
  bool printResult;
  Future<bool>? pendingConnection;
  Future<bool>? pendingPrint;
  @override
  final PrinterConnectionProfile connectionProfile;
  int connectCalls = 0;
  int discoveryCalls = 0;
  int printCalls = 0;
  int saveCalls = 0;

  FakePrinterRepository({
    this.selectedPrinter,
    this.connectResult = true,
    this.printResult = true,
    this.pendingConnection,
    this.pendingPrint,
    this.connectionProfile = PrinterConnectionProfile.androidBluetooth,
  });

  void emitDiscovery(PrinterDiscoverySnapshot snapshot) {
    _discoveryController.add(snapshot);
  }

  @override
  Future<bool> connect(SavedPrinter printer) async {
    connectCalls++;
    final connection = pendingConnection;
    if (connection != null) {
      return connection;
    }
    return connectResult;
  }

  @override
  Stream<PrinterDiscoverySnapshot> discoverPrinters() {
    discoveryCalls++;
    return _discoveryController.stream;
  }

  @override
  Future<SavedPrinter?> loadSelectedPrinter() async => selectedPrinter;

  @override
  Future<bool> printReceiptPng({
    required SavedPrinter printer,
    required Uint8List imageBytes,
    required void Function(double progress) onProgress,
  }) async {
    printCalls++;
    onProgress(0.5);
    final print = pendingPrint;
    if (print != null) {
      return print;
    }
    return printResult;
  }

  @override
  Future<void> saveSelectedPrinter(SavedPrinter printer) async {
    saveCalls++;
    selectedPrinter = printer;
  }

  Future<void> close() => _discoveryController.close();
}
