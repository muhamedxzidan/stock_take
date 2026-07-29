import 'dart:typed_data';

import '../models/printer_connection_profile.dart';
import '../models/printer_discovery_snapshot.dart';
import '../models/saved_printer.dart';

abstract class PrinterRepositoryBase {
  PrinterConnectionProfile get connectionProfile;

  Future<SavedPrinter?> loadSelectedPrinter();

  Future<void> saveSelectedPrinter(SavedPrinter printer);

  Stream<PrinterDiscoverySnapshot> discoverPrinters();

  Future<bool> connect(SavedPrinter printer);

  Future<bool> printReceiptPng({
    required SavedPrinter printer,
    required Uint8List imageBytes,
    required void Function(double progress) onProgress,
  });
}
