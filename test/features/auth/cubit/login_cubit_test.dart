import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/auth/cubit/login/login_cubit.dart';
import 'package:stock_take/features/auth/cubit/login/login_state.dart';
import 'package:stock_take/features/auth/data/repositories/auth_failure.dart';
import 'package:stock_take/features/auth/data/repositories/auth_repository.dart';

void main() {
  test('signIn emits submitting then success for valid credentials', () async {
    final repository = _FakeAuthRepository();
    final cubit = LoginCubit(repository);
    addTearDown(cubit.close);

    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<LoginSubmitting>(), isA<LoginSuccess>()]),
    );

    await cubit.signIn(
      email: 'worker@example.com',
      password: 'strong-password',
    );

    await states;
    expect(repository.signInCalls, 1);
  });

  test('signIn rejects invalid email without calling repository', () async {
    final repository = _FakeAuthRepository();
    final cubit = LoginCubit(repository);
    addTearDown(cubit.close);

    final states = expectLater(cubit.stream, emits(isA<LoginFailure>()));

    await cubit.signIn(email: 'invalid-email', password: 'password');

    await states;
    expect(repository.signInCalls, 0);
  });

  test('signIn exposes only the safe repository failure message', () async {
    final repository = _FakeAuthRepository(
      failure: const AuthFailure('بيانات الدخول غير صحيحة.'),
    );
    final cubit = LoginCubit(repository);
    addTearDown(cubit.close);

    final states = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<LoginSubmitting>(),
        isA<LoginFailure>().having(
          (state) => state.message,
          'message',
          'بيانات الدخول غير صحيحة.',
        ),
      ]),
    );

    await cubit.signIn(email: 'worker@example.com', password: 'wrong-password');

    await states;
  });

  test('signIn ignores a duplicate submit while request is pending', () async {
    final pendingSignIn = Completer<void>();
    final repository = _FakeAuthRepository(pendingSignIn: pendingSignIn);
    final cubit = LoginCubit(repository);
    addTearDown(cubit.close);

    final firstSubmit = cubit.signIn(
      email: 'worker@example.com',
      password: 'strong-password',
    );
    await Future<void>.delayed(Duration.zero);

    await cubit.signIn(
      email: 'worker@example.com',
      password: 'strong-password',
    );

    expect(repository.signInCalls, 1);
    pendingSignIn.complete();
    await firstSubmit;
  });
}

class _FakeAuthRepository implements AuthRepository {
  final AuthFailure? failure;
  final Completer<void>? pendingSignIn;
  int signInCalls = 0;

  _FakeAuthRepository({this.failure, this.pendingSignIn});

  @override
  bool get isSignedIn => false;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    signInCalls++;
    if (failure case final failure?) {
      throw failure;
    }
    await pendingSignIn?.future;
  }

  @override
  Future<void> signOut() async {}

  @override
  Stream<bool> watchAuthentication() => const Stream<bool>.empty();
}
