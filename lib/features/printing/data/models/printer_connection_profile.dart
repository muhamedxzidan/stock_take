enum PrinterConnectionMode {
  webBluetoothLowEnergy,
  androidBluetoothClassic,
  localAndroidBridge,
  unsupported,
}

class PrinterConnectionProfile {
  final PrinterConnectionMode mode;
  final bool isSupported;
  final bool requiresUserGestureForDiscovery;
  final bool persistsSelectionAcrossSessions;

  const PrinterConnectionProfile({
    required this.mode,
    required this.isSupported,
    required this.requiresUserGestureForDiscovery,
    required this.persistsSelectionAcrossSessions,
  });

  static const webBluetooth = PrinterConnectionProfile(
    mode: PrinterConnectionMode.webBluetoothLowEnergy,
    isSupported: true,
    requiresUserGestureForDiscovery: true,
    persistsSelectionAcrossSessions: false,
  );

  static const androidBluetooth = PrinterConnectionProfile(
    mode: PrinterConnectionMode.androidBluetoothClassic,
    isSupported: true,
    requiresUserGestureForDiscovery: false,
    persistsSelectionAcrossSessions: true,
  );

  static const unsupported = PrinterConnectionProfile(
    mode: PrinterConnectionMode.unsupported,
    isSupported: false,
    requiresUserGestureForDiscovery: false,
    persistsSelectionAcrossSessions: false,
  );
}
