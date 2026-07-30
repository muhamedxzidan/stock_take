enum PrinterConnectionMode { androidBluetoothClassic, unsupported }

class PrinterConnectionProfile {
  final PrinterConnectionMode mode;
  final bool isSupported;
  final bool persistsSelectionAcrossSessions;

  const PrinterConnectionProfile({
    required this.mode,
    required this.isSupported,
    required this.persistsSelectionAcrossSessions,
  });

  static const androidBluetooth = PrinterConnectionProfile(
    mode: PrinterConnectionMode.androidBluetoothClassic,
    isSupported: true,
    persistsSelectionAcrossSessions: true,
  );

  static const unsupported = PrinterConnectionProfile(
    mode: PrinterConnectionMode.unsupported,
    isSupported: false,
    persistsSelectionAcrossSessions: false,
  );
}
