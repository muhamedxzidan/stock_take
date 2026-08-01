import 'dart:async';

import '../data/models/printer_discovery_snapshot.dart';
import '../data/repositories/printer_repository_base.dart';

/// Owns the single active printer discovery subscription for [PrinterCubit].
class PrinterDiscoveryController {
  final PrinterRepositoryBase _repository;
  StreamSubscription<PrinterDiscoverySnapshot>? _subscription;

  PrinterDiscoveryController(this._repository);

  Future<void> start({
    required void Function(PrinterDiscoverySnapshot snapshot) onSnapshot,
    required void Function() onError,
  }) async {
    await stop();
    _subscription = _repository.discoverPrinters().listen(
      onSnapshot,
      onError: (_, _) => onError(),
    );
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
