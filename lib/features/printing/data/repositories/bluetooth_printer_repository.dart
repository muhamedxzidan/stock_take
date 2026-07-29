import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';

import '../models/printer_connection_profile.dart';
import '../models/printer_discovery_snapshot.dart';
import '../models/saved_printer.dart';
import 'printer_repository_base.dart';

class BluetoothPrinterRepository implements PrinterRepositoryBase {
  static const MethodChannel _preferencesChannel = MethodChannel(
    'stock_take/printer_preferences',
  );

  SavedPrinter? _sessionPrinter;

  @override
  PrinterConnectionProfile get connectionProfile {
    if (kIsWeb) {
      return PrinterConnectionProfile.webBluetooth;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
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
        message: 'اتصال الطابعة المباشر غير مدعوم على هذا الجهاز.',
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
    if (!connectionProfile.isSupported || imageBytes.length < 24) {
      return false;
    }

    final dimensions = _readPngDimensions(imageBytes);
    if (dimensions == null) {
      return false;
    }

    final firstAttempt = await _printOnce(
      printer: printer,
      imageBytes: imageBytes,
      imageWidth: dimensions.$1,
      imageHeight: dimensions.$2,
      onProgress: onProgress,
    );
    if (firstAttempt) {
      return true;
    }

    try {
      await FlutterBluetoothPrinter.disconnect(printer.address);
    } catch (_) {
      // A failed print may already close the socket. The retry reconnects it.
    }

    onProgress(0);
    return _printOnce(
      printer: printer,
      imageBytes: imageBytes,
      imageWidth: dimensions.$1,
      imageHeight: dimensions.$2,
      onProgress: onProgress,
    );
  }

  Future<bool> _printOnce({
    required SavedPrinter printer,
    required Uint8List imageBytes,
    required int imageWidth,
    required int imageHeight,
    required void Function(double progress) onProgress,
  }) async {
    try {
      return await FlutterBluetoothPrinter.printImageSingle(
        address: printer.address,
        imageBytes: imageBytes,
        imageWidth: imageWidth,
        imageHeight: imageHeight,
        paperSize: PaperSize.mm80,
        addFeeds: 3,
        cutPaper: false,
        keepConnected: true,
        onProgress: (total, sent) {
          onProgress(total == 0 ? 0 : sent / total);
        },
      );
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    } catch (_) {
      return false;
    }
  }

  (int, int)? _readPngDimensions(Uint8List bytes) {
    const pngSignature = <int>[137, 80, 78, 71, 13, 10, 26, 10];
    for (var index = 0; index < pngSignature.length; index++) {
      if (bytes[index] != pngSignature[index]) {
        return null;
      }
    }

    final data = ByteData.sublistView(bytes);
    final width = data.getUint32(16);
    final height = data.getUint32(20);
    if (width == 0 || height == 0) {
      return null;
    }
    return (width, height);
  }

  String get _permissionMessage {
    if (connectionProfile.mode == PrinterConnectionMode.webBluetoothLowEnergy) {
      return 'اسمح لموقع المخزن بالوصول إلى أجهزة البلوتوث من Chrome.';
    }
    return 'اسمح للتطبيق بالوصول إلى أجهزة البلوتوث القريبة.';
  }

  String get _unsupportedMessage {
    if (connectionProfile.mode == PrinterConnectionMode.webBluetoothLowEnergy) {
      return 'Web Bluetooth غير متاح هنا. افتح الموقع من Chrome على Android '
          'ومن خلال رابط HTTPS.';
    }
    return 'هذا الجهاز لا يدعم اتصال الطابعة بالبلوتوث.';
  }

  String get _searchFailureMessage {
    if (connectionProfile.mode == PrinterConnectionMode.webBluetoothLowEnergy) {
      return 'تعذر فتح بحث البلوتوث من Chrome. أعد المحاولة من زر البحث، '
          'وتأكد أن الموقع يعمل عبر HTTPS.';
    }
    return 'تعذر البحث عن الطابعات. تحقق من صلاحية البلوتوث.';
  }
}
