import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';

import '../models/printer_connection_profile.dart';
import '../models/printer_discovery_snapshot.dart';
import '../models/saved_printer.dart';
import '../services/selected_printer_store.dart';
import '../services/thermal_receipt_image_slicer.dart';
import '../services/thermal_receipt_print_job.dart';
import 'printer_repository_base.dart';

class BluetoothPrinterRepository implements PrinterRepositoryBase {
  final SelectedPrinterStore _printerStore;
  final ThermalReceiptPrintJob _printJob;
  SavedPrinter? _sessionPrinter;

  BluetoothPrinterRepository({
    ReceiptImageSlicer? imageSlicer,
    ReceiptImagePrinter? imagePrinter,
    SelectedPrinterStore? printerStore,
  }) : _printerStore = printerStore ?? const SelectedPrinterStore(),
       _printJob = ThermalReceiptPrintJob(
         sliceImage: imageSlicer ?? const ThermalReceiptImageSlicer().slicePng,
         printImage: imagePrinter ?? _printImageWithBluetooth,
       );

  @override
  PrinterConnectionProfile get connectionProfile {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return PrinterConnectionProfile.androidBluetooth;
    }
    return PrinterConnectionProfile.unsupported;
  }

  bool get _usesNativePreferences =>
      connectionProfile.mode == PrinterConnectionMode.androidBluetoothClassic;

  @override
  Future<SavedPrinter?> loadSelectedPrinter() async {
    if (!_usesNativePreferences) {
      return _sessionPrinter;
    }

    _sessionPrinter = await _printerStore.load() ?? _sessionPrinter;
    return _sessionPrinter;
  }

  @override
  Future<void> saveSelectedPrinter(SavedPrinter printer) async {
    _sessionPrinter = printer;
    if (!_usesNativePreferences) {
      return;
    }

    await _printerStore.save(printer);
  }

  @override
  Stream<PrinterDiscoverySnapshot> discoverPrinters() async* {
    if (!connectionProfile.isSupported) {
      yield const PrinterDiscoverySnapshot(
        availability: PrinterDiscoveryAvailability.unsupported,
        message: 'الطباعة بالبلوتوث متاحة من تطبيق Android فقط.',
      );
      return;
    }

    try {
      await for (final discoveryState in FlutterBluetoothPrinter.discovery) {
        if (discoveryState is DiscoveryResult) {
          yield PrinterDiscoverySnapshot(
            availability: PrinterDiscoveryAvailability.ready,
            devices: discoveryState.devices
                .map(
                  (device) => SavedPrinter(
                    address: device.address,
                    name: device.name ?? '',
                  ),
                )
                .toList(growable: false),
          );
        } else if (discoveryState is BluetoothDisabledState) {
          yield const PrinterDiscoverySnapshot(
            availability: PrinterDiscoveryAvailability.bluetoothDisabled,
            message: 'شغّل البلوتوث ثم أعد البحث.',
          );
        } else if (discoveryState is PermissionRestrictedState) {
          yield PrinterDiscoverySnapshot(
            availability: PrinterDiscoveryAvailability.permissionDenied,
            message: _permissionMessage,
          );
        } else if (discoveryState is UnsupportedBluetoothState) {
          yield PrinterDiscoverySnapshot(
            availability: PrinterDiscoveryAvailability.unsupported,
            message: _unsupportedMessage,
          );
        } else {
          yield const PrinterDiscoverySnapshot(
            availability: PrinterDiscoveryAvailability.searching,
          );
        }
      }
    } on PlatformException {
      yield PrinterDiscoverySnapshot(
        availability: PrinterDiscoveryAvailability.failure,
        message: _searchFailureMessage,
      );
    } on MissingPluginException {
      yield PrinterDiscoverySnapshot(
        availability: PrinterDiscoveryAvailability.unsupported,
        message: _unsupportedMessage,
      );
    } catch (_) {
      yield PrinterDiscoverySnapshot(
        availability: PrinterDiscoveryAvailability.failure,
        message: _searchFailureMessage,
      );
    }
  }

  @override
  Future<bool> connect(SavedPrinter printer) async {
    if (!connectionProfile.isSupported) {
      return false;
    }

    try {
      return await FlutterBluetoothPrinter.connect(printer.address);
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> printReceiptPng({
    required SavedPrinter printer,
    required Uint8List imageBytes,
    required void Function(double progress) onProgress,
  }) async {
    if (!connectionProfile.isSupported) {
      return false;
    }

    try {
      return _printJob.print(
        printer: printer,
        imageBytes: imageBytes,
        onProgress: onProgress,
      );
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _printImageWithBluetooth({
    required String address,
    required Uint8List imageBytes,
    required int imageWidth,
    required int imageHeight,
    required int addFeeds,
    required void Function(int total, int sent) onProgress,
  }) {
    return FlutterBluetoothPrinter.printImageSingle(
      address: address,
      imageBytes: imageBytes,
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      paperSize: PaperSize.mm80,
      addFeeds: addFeeds,
      cutPaper: false,
      keepConnected: true,
      onProgress: onProgress,
    );
  }

  String get _permissionMessage {
    return 'اسمح للتطبيق بالوصول إلى أجهزة البلوتوث القريبة.';
  }

  String get _unsupportedMessage =>
      'الطباعة بالبلوتوث متاحة من تطبيق Android فقط.';

  String get _searchFailureMessage =>
      'تعذر البحث عن الطابعات. تحقق من صلاحية البلوتوث.';
}
