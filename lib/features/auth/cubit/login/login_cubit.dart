import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_failure.dart';
import '../../data/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(const LoginInitial());

  Future<void> signIn({required String email, required String password}) async {
    if (state is LoginSubmitting) {
      return;
    }

    final normalizedEmail = email.trim();
    if (!_isValidEmail(normalizedEmail)) {
      emit(const LoginFailure('اكتب بريدًا إلكترونيًا صحيحًا.'));
      return;
    }
    if (password.isEmpty) {
      emit(const LoginFailure('اكتب كلمة المرور.'));
      return;
    }

    emit(const LoginSubmitting());
    try {
      await _authRepository.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      emit(const LoginSuccess());
    } on AuthFailure catch (failure) {
      emit(LoginFailure(failure.message));
    } catch (_) {
      emit(const LoginFailure('تعذر تسجيل الدخول الآن. حاول مرة أخرى.'));
    }
  }

  bool _isValidEmail(String email) {
    final separatorIndex = email.indexOf('@');
    return separatorIndex > 0 &&
        separatorIndex < email.length - 1 &&
        email.substring(separatorIndex + 1).contains('.');
  }
}
