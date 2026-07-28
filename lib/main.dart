import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_take/firebase_options.dart';

import 'core/constants/app_strings.dart';
import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';

import 'features/dashboard/cubit/dashboard_cubit.dart';

import 'features/items/cubit/items_cubit.dart';
import 'features/items/cubit/item_catalog_cubit.dart';

import 'features/returns/cubit/returns_cubit.dart';
import 'features/returns/cubit/return_resolution_cubit.dart';

import 'features/stocktake/cubit/stocktake_cubit.dart';

import 'features/transactions/cubit/transactions_cubit.dart';
import 'features/transactions/cubit/movement_history_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();
  runApp(const StockTakeApp());
}

class StockTakeApp extends StatelessWidget {
  const StockTakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Mobile baseline design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<DashboardCubit>(
              create: (context) => serviceLocator<DashboardCubit>(),
            ),

            BlocProvider<ItemsCubit>(
              create: (context) => serviceLocator<ItemsCubit>(),
            ),
            BlocProvider<ItemCatalogCubit>(
              create: (context) => serviceLocator<ItemCatalogCubit>(),
            ),
            BlocProvider<ReturnsCubit>(
              create: (context) => serviceLocator<ReturnsCubit>(),
            ),
            BlocProvider<ReturnResolutionCubit>(
              create: (context) => serviceLocator<ReturnResolutionCubit>(),
            ),
            BlocProvider<TransactionsCubit>(
              create: (context) => serviceLocator<TransactionsCubit>(),
            ),
            BlocProvider<MovementHistoryCubit>(
              create: (context) => serviceLocator<MovementHistoryCubit>(),
            ),
            BlocProvider<StocktakeCubit>(
              create: (context) => serviceLocator<StocktakeCubit>(),
            ),
          ],
          child: MaterialApp.router(
            title: AppStrings.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: serviceLocator<GoRouter>(),
            builder: (context, widget) {
              return Directionality(
                textDirection: TextDirection.rtl, // Native RTL Arabic Support
                child: widget ?? const SizedBox.shrink(),
              );
            },
          ),
        );
      },
    );
  }
}
