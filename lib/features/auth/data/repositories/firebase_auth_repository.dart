import 'package:firebase_auth/firebase_auth.dart';

import 'auth_failure.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  @override
  bool get isSignedIn => _firebaseAuth.currentUser != null;

  @override
  Stream<bool> watchAuthentication() {
    return _firebaseAuth.authStateChanges().map((user) => user != null);
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseFailure(error);
    } catch (_) {
      throw const AuthFailure(
        'تعذر تسجيل الدخول الآن. تحقق من الاتصال وحاول مرة أخرى.',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException {
      throw const AuthFailure('تعذر تسجيل الخروج. حاول مرة أخرى.');
    } catch (_) {
      throw const AuthFailure('تعذر تسجيل الخروج. حاول مرة أخرى.');
    }
  }

  AuthFailure _mapFirebaseFailure(FirebaseAuthException error) {
    return switch (error.code) {
      'invalid-email' => const AuthFailure('صيغة البريد الإلكتروني غير صحيحة.'),
      'user-disabled' => const AuthFailure(
        'هذا الحساب موقوف. راجع مسؤول النظام.',
      ),
      'too-many-requests' => const AuthFailure(
        'تم إيقاف المحاولات مؤقتًا. انتظر قليلًا ثم حاول مرة أخرى.',
      ),
      'network-request-failed' => const AuthFailure(
        'لا يوجد اتصال مستقر بالإنترنت.',
      ),
      'invalid-credential' || 'user-not-found' || 'wrong-password' =>
        const AuthFailure('البريد الإلكتروني أو كلمة المرور غير صحيحة.'),
      _ => const AuthFailure('تعذر تسجيل الدخول الآن. حاول مرة أخرى.'),
    };
  }
}
