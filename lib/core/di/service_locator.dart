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
import '../../features/printing/cubit/printer_cubit.dart';
import '../../features/printing/data/repositories/bluetooth_printer_repository.dart';
import '../../features/printing/data/repositories/printer_repository_base.dart';
import '../../features/returns/cubit/returns_cubit.dart';
import '../../features/returns/cubit/return_resolution_cubit.dart';
import '../../features/returns/data/repositories/returns_repository.dart';
import '../../features/returns/data/repositories/returns_repository_base.dart';
import '../../features/stocktake/cubit/stocktake_cubit.dart';
import '../../features/stocktake/data/repositories/stocktake_repository.dart';
import '../../features/stocktake/data/repositories/stocktake_repository_base.dart';
import '../../features/transactions/cubit/transactions_cubit.dart';
import '../../features/transactions/cubit/movement_history_cubit.dart';
import '../../features/transactions/data/repositories/transactions_repository.dart';
import '../../features/transactions/data/repositories/transactions_repository_base.dart';
import '../constants/app_router.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> configureDependencies({
  AuthRepository? authRepository,
  ItemsRepositoryBase? itemsRepository,
  ReturnsRepositoryBase? returnsRepository,
  StocktakeRepositoryBase? stocktakeRepository,
  TransactionsRepositoryBase? transactionsRepository,
  PrinterRepositoryBase? printerRepository,
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
  if (returnsRepository != null) {
    serviceLocator.registerSingleton<ReturnsRepositoryBase>(returnsRepository);
  } else {
    serviceLocator.registerLazySingleton<ReturnsRepositoryBase>(
      () => ReturnsRepository(
        firestore: serviceLocator<FirebaseFirestore>(),
        firebaseAuth: serviceLocator<FirebaseAuth>(),
      ),
    );
  }
  if (transactionsRepository != null) {
    serviceLocator.registerSingleton<TransactionsRepositoryBase>(
      transactionsRepository,
    );
  } else {
    serviceLocator.registerLazySingleton<TransactionsRepositoryBase>(
      () => TransactionsRepository(
        firestore: serviceLocator<FirebaseFirestore>(),
        firebaseAuth: serviceLocator<FirebaseAuth>(),
      ),
    );
  }
  if (stocktakeRepository != null) {
    serviceLocator.registerSingleton<StocktakeRepositoryBase>(
      stocktakeRepository,
    );
  } else {
    serviceLocator.registerLazySingleton<StocktakeRepositoryBase>(
      () => StocktakeRepository(
        firestore: serviceLocator<FirebaseFirestore>(),
        firebaseAuth: serviceLocator<FirebaseAuth>(),
      ),
    );
  }
  if (printerRepository != null) {
    serviceLocator.registerSingleton<PrinterRepositoryBase>(printerRepository);
  } else {
    serviceLocator.registerLazySingleton<PrinterRepositoryBase>(
      BluetoothPrinterRepository.new,
    );
  }

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
  serviceLocator.registerFactory<ReturnsCubit>(
    () => ReturnsCubit(serviceLocator<ReturnsRepositoryBase>()),
  );
  serviceLocator.registerFactory<ReturnResolutionCubit>(
    () => ReturnResolutionCubit(serviceLocator<ReturnsRepositoryBase>()),
  );
  serviceLocator.registerFactory<TransactionsCubit>(
    () => TransactionsCubit(serviceLocator<TransactionsRepositoryBase>()),
  );
  serviceLocator.registerFactory<MovementHistoryCubit>(
    () => MovementHistoryCubit(serviceLocator<TransactionsRepositoryBase>()),
  );
  serviceLocator.registerFactory<PrinterCubit>(
    () => PrinterCubit(serviceLocator<PrinterRepositoryBase>()),
  );
  serviceLocator.registerFactory<StocktakeCubit>(
    () => StocktakeCubit(serviceLocator<StocktakeRepositoryBase>()),
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
      createStocktakeCubit: () => serviceLocator<StocktakeCubit>(),
    ),
    dispose: (router) => router.dispose(),
  );
}
