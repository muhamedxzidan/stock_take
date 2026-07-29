import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/auth/data/repositories/firebase_auth_repository.dart';

void main() {
  group('mapFirebaseAuthFailureCode', () {
    const invalidCredentialsMessage =
        'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

    for (final code in [
      'invalid-credential',
      'invalid-login-credentials',
      'INVALID_LOGIN_CREDENTIALS',
      'auth/invalid-login-credentials',
      ' AUTH/INVALID_LOGIN_CREDENTIALS ',
      'user-not-found',
      'wrong-password',
    ]) {
      test('maps $code to the safe invalid credentials message', () {
        final failure = mapFirebaseAuthFailureCode(code);

        expect(failure.message, invalidCredentialsMessage);
      });
    }

    test('keeps the generic message for an unknown Firebase code', () {
      final failure = mapFirebaseAuthFailureCode('unexpected-code');

      expect(failure.message, 'تعذر تسجيل الدخول الآن. حاول مرة أخرى.');
    });
  });
}
