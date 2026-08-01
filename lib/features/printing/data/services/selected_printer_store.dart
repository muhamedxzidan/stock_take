import 'package:flutter/services.dart';

import '../models/saved_printer.dart';

/// Persists the printer identity selected on this Android device.
class SelectedPrinterStore {
  static const MethodChannel _channel = MethodChannel(
    'stock_take/printer_preferences',
  );

  const SelectedPrinterStore();

  Future<SavedPrinter?> load() async {
    try {
      final value = await _channel.invokeMapMethod<Object?, Object?>(
        'loadSelectedPrinter',
      );
      final address = value?['address'];
      final name = value?['name'];
      if (address is! String || address.trim().isEmpty) {
        return null;
      }
      return SavedPrinter(address: address, name: name is String ? name : '');
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> save(SavedPrinter printer) {
    return _channel.invokeMethod<void>('saveSelectedPrinter', {
      'address': printer.address,
      'name': printer.name,
    });
  }
}
