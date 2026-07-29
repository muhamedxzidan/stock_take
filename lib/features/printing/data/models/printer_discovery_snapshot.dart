import 'saved_printer.dart';

enum PrinterDiscoveryAvailability {
  idle,
  searching,
  ready,
  bluetoothDisabled,
  permissionDenied,
  unsupported,
  failure,
}

class PrinterDiscoverySnapshot {
  final PrinterDiscoveryAvailability availability;
  final List<SavedPrinter> devices;
  final String? message;

  const PrinterDiscoverySnapshot({
    required this.availability,
    this.devices = const [],
    this.message,
  });
}
