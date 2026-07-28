import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/core/di/service_locator.dart';
import 'package:stock_take/features/auth/data/repositories/auth_repository.dart';
import 'package:stock_take/main.dart';

import '../../../support/fake_items_repository.dart';

void main() {
  late _MutableAuthRepository authRepository;
  late FakeItemsRepository itemsRepository;

  setUp(() async {
    authRepository = _MutableAuthRepository();
    itemsRepository = FakeItemsRepository();
    await configureDependencies(
      authRepository: authRepository,
      itemsRepository: itemsRepository,
      reset: true,
    );
  });

  tearDown(() async {
    await serviceLocator.reset();
    await authRepository.close();
    await itemsRepository.close();
  });

  testWidgets('signed-out user sees login and enters the app after success', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(900, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const StockTakeApp());
    await tester.pumpAndSettle();

    expect(find.text('تسجيل الدخول'), findsOneWidget);
    expect(find.text('حركة جديدة'), findsNothing);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'worker@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'strong-password');
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();

    expect(authRepository.signInCalls, 1);
    expect(find.text('حركة جديدة'), findsAtLeastNWidgets(1));
    expect(find.text('تسجيل الدخول'), findsNothing);
  });

  testWidgets('login stays usable on phone and tablet sizes', (
    WidgetTester tester,
  ) async {
    for (final size in const [Size(390, 844), Size(1280, 900)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;

      await tester.pumpWidget(const StockTakeApp());
      await tester.pumpAndSettle();

      expect(find.text('تسجيل الدخول'), findsOneWidget);
      expect(find.byKey(const Key('login-submit')), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}

class _MutableAuthRepository implements AuthRepository {
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  bool _isSignedIn = false;
  int signInCalls = 0;

  @override
  bool get isSignedIn => _isSignedIn;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    signInCalls++;
    _isSignedIn = true;
    _controller.add(true);
  }

  @override
  Future<void> signOut() async {
    _isSignedIn = false;
    _controller.add(false);
  }

  @override
  Stream<bool> watchAuthentication() => _controller.stream;

  Future<void> close() => _controller.close();
}
