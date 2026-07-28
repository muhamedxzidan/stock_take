import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/cubit/login/login_cubit.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/firebase_auth_repository.dart';
import '../../features/auth/presentation/routing/auth_session_notifier.dart';
import '../../features/dashboard/cubit/dashboard_cubit.dart';
import '../../features/dashboard/data/repositories/dashboard_repository.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_base.dart';
import '../../features/items/cubit/items_cubit.dart';
import '../../features/items/cubit/item_catalog_cubit.dart';
import '../../features/items/data/repositories/items_repository.dart';
import '../../features/items/data/repositories/items_repository_base.dart';
import '../../features/transactions/cubit/transactions_cubit.dart';
import '../../features/transactions/data/repositories/transactions_repository.dart';
import '../../features/transactions/data/repositories/transactions_repository_base.dart';
import '../constants/app_router.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> configureDependencies({
  AuthRepository? authRepository,
  ItemsRepositoryBase? itemsRepository,
  bool reset = false,
}) async {
  if (reset) {
    await serviceLocator.reset();
  }

  if (serviceLocator.isRegistered<GoRouter>()) {
    return;
  }

  serviceLocator.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );
  serviceLocator.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  if (authRepository != null) {
    serviceLocator.registerSingleton<AuthRepository>(authRepository);
  } else {
    serviceLocator.registerLazySingleton<AuthRepository>(
      () =>
          FirebaseAuthRepository(firebaseAuth: serviceLocator<FirebaseAuth>()),
    );
  }

  if (itemsRepository != null) {
    serviceLocator.registerSingleton<ItemsRepositoryBase>(itemsRepository);
  } else {
    serviceLocator.registerLazySingleton<ItemsRepositoryBase>(
      () => ItemsRepository(
        firestore: serviceLocator<FirebaseFirestore>(),
        firebaseAuth: serviceLocator<FirebaseAuth>(),
      ),
    );
  }
  serviceLocator.registerLazySingleton<DashboardRepositoryBase>(
    () => DashboardRepository(serviceLocator<ItemsRepositoryBase>()),
  );
  serviceLocator.registerLazySingleton<TransactionsRepositoryBase>(
    TransactionsRepository.new,
  );

  serviceLocator.registerFactory<LoginCubit>(
    () => LoginCubit(serviceLocator<AuthRepository>()),
  );
  serviceLocator.registerFactory<DashboardCubit>(
    () => DashboardCubit(serviceLocator<DashboardRepositoryBase>()),
  );
  serviceLocator.registerFactory<ItemsCubit>(
    () => ItemsCubit(serviceLocator<ItemsRepositoryBase>()),
  );
  serviceLocator.registerFactory<ItemCatalogCubit>(
    () => ItemCatalogCubit(serviceLocator<ItemsRepositoryBase>()),
  );
  serviceLocator.registerFactory<TransactionsCubit>(
    () =>
        TransactionsCubit(serviceLocator<TransactionsRepositoryBase>())
          ..loadTransactions(),
  );

  serviceLocator.registerLazySingleton<AuthSessionNotifier>(
    () => AuthSessionNotifier(serviceLocator<AuthRepository>()),
    dispose: (notifier) => notifier.dispose(),
  );
  serviceLocator.registerLazySingleton<GoRouter>(
    () => AppRouter.create(
      authRepository: serviceLocator<AuthRepository>(),
      authSessionNotifier: serviceLocator<AuthSessionNotifier>(),
      createLoginCubit: () => serviceLocator<LoginCubit>(),
    ),
    dispose: (router) => router.dispose(),
  );
}
