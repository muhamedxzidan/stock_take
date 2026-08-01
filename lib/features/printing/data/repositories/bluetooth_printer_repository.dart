import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';

import '../models/printer_connection_profile.dart';
import '../models/printer_discovery_snapshot.dart';
import '../models/saved_printer.dart';
import '../services/thermal_receipt_image_slicer.dart';
import 'printer_repository_base.dart';

typedef ReceiptImageSlicer =
    Future<List<ThermalReceiptImageSlice>> Function(Uint8List imageBytes);

typedef ReceiptImagePrinter =
    Future<bool> Function({
      required String address,
      required Uint8List imageBytes,
      required int imageWidth,
      required int imageHeight,
      required int addFeeds,
      required void Function(int total, int sent) onProgress,
    });

class BluetoothPrinterRepository implements PrinterRepositoryBase {
  static const MethodChannel _preferencesChannel = MethodChannel(
    'stock_take/printer_preferences',
  );

  final ReceiptImageSlicer _sliceImage;
  final ReceiptImagePrinter _printImage;
  SavedPrinter? _sessionPrinter;

  BluetoothPrinterRepository({
    ReceiptImageSlicer? imageSlicer,
    ReceiptImagePrinter? imagePrinter,
  }) : _sliceImage = imageSlicer ?? const ThermalReceiptImageSlicer().slicePng,
       _printImage = imagePrinter ?? _printImageWithBluetooth;

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

    try {
      final value = await _preferencesChannel.invokeMapMethod<Object?, Object?>(
        'loadSelectedPrinter',
      );
      final address = value?['address'];
      final name = value?['name'];
      if (address is! String || address.trim().isEmpty) {
        return _sessionPrinter;
      }
      _sessionPrinter = SavedPrinter(
        address: address,
        name: name is String ? name : '',
      );
      return _sessionPrinter;
    } on PlatformException {
      return _sessionPrinter;
    } on MissingPluginException {
      return _sessionPrinter;
    } catch (_) {
      return _sessionPrinter;
    }
  }

  @override
  Future<void> saveSelectedPrinter(SavedPrinter printer) async {
    _sessionPrinter = printer;
    if (!_usesNativePreferences) {
      return;
    }

    await _preferencesChannel.invokeMethod<void>('saveSelectedPrinter', {
      'address': printer.address,
      'name': printer.name,
    });
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
      final slices = await _sliceImage(imageBytes);
      if (slices.isEmpty) {
        return false;
      }

      for (var index = 0; index < slices.length; index++) {
        final slice = slices[index];
        final printed = await _printSlice(
          printer: printer,
          slice: slice,
          isLast: index == slices.length - 1,
          onProgress: (sliceProgress) {
            onProgress((index + sliceProgress) / slices.length);
          },
        );
        if (!printed) {
          return false;
        }
        onProgress((index + 1) / slices.length);
      }
      return true;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _printSlice({
    required SavedPrinter printer,
    required ThermalReceiptImageSlice slice,
    required bool isLast,
    required void Function(double progress) onProgress,
  }) async {
    return _printImage(
      address: printer.address,
      imageBytes: slice.bytes,
      imageWidth: slice.width,
      imageHeight: slice.height,
      addFeeds: isLast ? 3 : 0,
      onProgress: (total, sent) {
        final progress = total <= 0
            ? 0.0
            : (sent / total).clamp(0.0, 1.0).toDouble();
        onProgress(progress);
      },
    );
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
