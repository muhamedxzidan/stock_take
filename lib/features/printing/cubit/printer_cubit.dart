import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/printer_discovery_snapshot.dart';
import '../data/models/saved_printer.dart';
import '../data/repositories/printer_repository_base.dart';
import 'printer_discovery_controller.dart';
import 'printer_state.dart';

class PrinterCubit extends Cubit<PrinterState> {
  final PrinterRepositoryBase _repository;
  late final PrinterDiscoveryController _discovery;
  bool _initialized = false;
  bool _selectionInProgress = false;
  bool _printInProgress = false;

  PrinterCubit(this._repository)
    : super(PrinterState(connectionProfile: _repository.connectionProfile)) {
    _discovery = PrinterDiscoveryController(_repository);
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    try {
      final selectedPrinter = await _repository.loadSelectedPrinter();
      if (isClosed) {
        return;
      }
      emit(
        state.copyWith(
          selectedPrinter: selectedPrinter,
          availability: selectedPrinter == null
              ? PrinterDiscoveryAvailability.idle
              : PrinterDiscoveryAvailability.ready,
          message: null,
        ),
      );
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            availability: PrinterDiscoveryAvailability.failure,
            message: 'تعذر تحميل إعداد الطابعة المحفوظ.',
          ),
        );
      }
    }
  }

  Future<void> startDiscovery() async {
    if (_selectionInProgress || _printInProgress) {
      return;
    }

    if (isClosed) {
      return;
    }
    emit(
      state.copyWith(
        availability: PrinterDiscoveryAvailability.searching,
        discoveredPrinters: const [],
        message: null,
      ),
    );

    await _discovery.start(
      onSnapshot: (snapshot) {
        if (isClosed) {
          return;
        }
        emit(
          state.copyWith(
            availability: snapshot.availability,
            discoveredPrinters: snapshot.devices,
            message: snapshot.message,
          ),
        );
      },
      onError: () {
        if (isClosed) {
          return;
        }
        emit(
          state.copyWith(
            availability: PrinterDiscoveryAvailability.failure,
            message: 'تعذر البحث عن الطابعات الآن.',
          ),
        );
      },
    );
  }

  Future<void> stopDiscovery() async {
    await _discovery.stop();
  }

  Future<bool> selectAndConnect(SavedPrinter printer) async {
    if (_selectionInProgress || _printInProgress) {
      return false;
    }

    _selectionInProgress = true;
    emit(state.copyWith(isConnecting: true, message: null));
    try {
      final connected = await _repository.connect(printer);
      if (isClosed) {
        return false;
      }
      if (!connected) {
        emit(
          state.copyWith(
            isConnecting: false,
            message:
                'تعذر الاتصال بـ ${printer.displayName}. '
                'تأكد أنها تعمل ومقترنة بالتابلت.',
          ),
        );
        return false;
      }

      await _repository.saveSelectedPrinter(printer);
      if (isClosed) {
        return false;
      }
      emit(
        state.copyWith(
          selectedPrinter: printer,
          availability: PrinterDiscoveryAvailability.ready,
          isConnecting: false,
          message: 'تم اعتماد ${printer.displayName} للطباعة.',
        ),
      );
      return true;
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isConnecting: false,
            message: 'تم الاتصال، لكن تعذر حفظ الطابعة على هذا الجهاز.',
          ),
        );
      }
      return false;
    } finally {
      _selectionInProgress = false;
    }
  }

  /// Sends already-rendered receipt bytes; rendering remains a presentation concern.
  Future<bool> printReceipt(Uint8List imageBytes) async {
    final printer = state.selectedPrinter;
    if (printer == null || _printInProgress || _selectionInProgress) {
      return false;
    }

    _printInProgress = true;
    emit(
      state.copyWith(isPrinting: true, printingProgress: 0.0, message: null),
    );
    try {
      final printed = await _repository.printReceiptPng(
        printer: printer,
        imageBytes: imageBytes,
        onProgress: (progress) {
          if (!isClosed && _printInProgress) {
            emit(state.copyWith(printingProgress: progress.clamp(0.0, 1.0)));
          }
        },
      );
      if (isClosed) {
        return false;
      }
      if (printed) {
        emit(
          state.copyWith(
            isPrinting: false,
            printingProgress: 1.0,
            message: 'تم إرسال الإيصال إلى ${printer.displayName}.',
          ),
        );
        return true;
      }

      emit(
        state.copyWith(
          isPrinting: false,
          printingProgress: null,
          message:
              'تعذر إرسال الإيصال. تأكد أن ${printer.displayName} تعمل '
              'وقريبة ثم حاول مرة أخرى.',
        ),
      );
      return false;
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isPrinting: false,
            printingProgress: null,
            message: 'حدث خطأ أثناء الطباعة. لم تتكرر حركة المخزون.',
          ),
        );
      }
      return false;
    } finally {
      _printInProgress = false;
    }
  }

  @override
  Future<void> close() async {
    await _discovery.stop();
    return super.close();
  }
}
