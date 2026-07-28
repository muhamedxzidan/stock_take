sealed class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginSubmitting extends LoginState {
  const LoginSubmitting();
}

final class LoginSuccess extends LoginState {
  const LoginSuccess();
}

final class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);
}
