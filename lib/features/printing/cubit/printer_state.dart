import '../data/models/printer_connection_profile.dart';
import '../data/models/printer_discovery_snapshot.dart';
import '../data/models/saved_printer.dart';

class PrinterState {
  static const Object _notProvided = Object();

  final SavedPrinter? selectedPrinter;
  final List<SavedPrinter> discoveredPrinters;
  final PrinterConnectionProfile connectionProfile;
  final PrinterDiscoveryAvailability availability;
  final bool isConnecting;
  final bool isPrinting;
  final double? printingProgress;
  final String? message;

  const PrinterState({
    this.selectedPrinter,
    this.discoveredPrinters = const [],
    this.connectionProfile = PrinterConnectionProfile.unsupported,
    this.availability = PrinterDiscoveryAvailability.idle,
    this.isConnecting = false,
    this.isPrinting = false,
    this.printingProgress,
    this.message,
  });

  PrinterState copyWith({
    Object? selectedPrinter = _notProvided,
    List<SavedPrinter>? discoveredPrinters,
    PrinterConnectionProfile? connectionProfile,
    PrinterDiscoveryAvailability? availability,
    bool? isConnecting,
    bool? isPrinting,
    Object? printingProgress = _notProvided,
    Object? message = _notProvided,
  }) {
    return PrinterState(
      selectedPrinter: identical(selectedPrinter, _notProvided)
          ? this.selectedPrinter
          : selectedPrinter as SavedPrinter?,
      discoveredPrinters: discoveredPrinters ?? this.discoveredPrinters,
      connectionProfile: connectionProfile ?? this.connectionProfile,
      availability: availability ?? this.availability,
      isConnecting: isConnecting ?? this.isConnecting,
      isPrinting: isPrinting ?? this.isPrinting,
      printingProgress: identical(printingProgress, _notProvided)
          ? this.printingProgress
          : printingProgress as double?,
      message: identical(message, _notProvided)
          ? this.message
          : message as String?,
    );
  }
}
