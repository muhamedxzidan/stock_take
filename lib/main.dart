import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/app_router.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';

import 'features/dashboard/cubit/dashboard_cubit.dart';
import 'features/dashboard/data/repositories/dashboard_repository.dart';

import 'features/items/cubit/items_cubit.dart';
import 'features/items/data/repositories/items_repository.dart';

import 'features/transactions/cubit/transactions_cubit.dart';
import 'features/transactions/data/repositories/transactions_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
              create: (context) => DashboardCubit(DashboardRepository())..loadDashboardData(),
            ),
            BlocProvider<ItemsCubit>(
              create: (context) => ItemsCubit(ItemsRepository()),
            ),
            BlocProvider<TransactionsCubit>(
              create: (context) => TransactionsCubit(TransactionsRepository())..loadTransactions(),
            ),
          ],
          child: MaterialApp.router(
            title: AppStrings.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: AppRouter.router,
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
