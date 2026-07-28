abstract class AuthRepository {
  bool get isSignedIn;

  Stream<bool> watchAuthentication();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
