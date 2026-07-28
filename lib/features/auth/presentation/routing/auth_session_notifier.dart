import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/repositories/auth_repository.dart';

class AuthSessionNotifier extends ChangeNotifier {
  late final StreamSubscription<bool> _subscription;

  AuthSessionNotifier(AuthRepository authRepository) {
    _subscription = authRepository.watchAuthentication().listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
