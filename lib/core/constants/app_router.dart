import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/cubit/login/login_cubit.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/routing/auth_session_notifier.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/items/presentation/screens/add_item_screen.dart';
import '../../features/returns/presentation/screens/warehouse_return_screen.dart';
import '../../features/stocktake/cubit/stocktake_cubit.dart';
import '../../features/transactions/presentation/screens/new_movement_screen.dart';
import '../../features/transactions/presentation/screens/stock_adjustment_screen.dart';
import '../../features/transactions/presentation/screens/transaction_history_screen.dart';
import '../../features/transactions/presentation/widgets/movement_ui_types.dart';
import '../shared_widgets/main_shell_screen.dart';
import 'app_routes.dart';

/// AppRouter configures GoRouter with a persistent ShellRoute for Tablet & Mobile navigation.
class AppRouter {
  AppRouter._();

  static GoRouter create({
    required AuthRepository authRepository,
    required AuthSessionNotifier authSessionNotifier,
    required LoginCubit Function() createLoginCubit,
    required StocktakeCubit Function() createStocktakeCubit,
  }) {
    return GoRouter(
      initialLocation: AppRoutes.newMovement,
      refreshListenable: authSessionNotifier,
      redirect: (BuildContext context, GoRouterState state) {
        final isOnLogin = state.matchedLocation == AppRoutes.login;

        if (!authRepository.isSignedIn) {
          return isOnLogin ? null : AppRoutes.login;
        }
        if (isOnLogin) {
          return AppRoutes.newMovement;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.login,
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider<LoginCubit>(
              create: (_) => createLoginCubit(),
              child: const LoginScreen(),
            );
          },
        ),
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return MainShellScreen(
              state: state,
              onLogout: authRepository.signOut,
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: AppRoutes.newMovement,
              builder: (BuildContext context, GoRouterState state) {
                final initialMovementKind =
                    state.uri.queryParameters['type'] == 'outbound'
                    ? MovementKind.outbound
                    : MovementKind.inbound;
                return NewMovementScreen(
                  key: ValueKey(initialMovementKind),
                  initialMovementKind: initialMovementKind,
                );
              },
            ),
            GoRoute(
              path: AppRoutes.dashboard,
              builder: (BuildContext context, GoRouterState state) =>
                  const DashboardScreen(),
            ),
            GoRoute(
              path: AppRoutes.addItem,
              builder: (BuildContext context, GoRouterState state) =>
                  const AddItemScreen(),
            ),
            GoRoute(
              path: AppRoutes.inboundEntry,
              redirect: (BuildContext context, GoRouterState state) =>
                  AppRoutes.newInboundMovement,
            ),
            GoRoute(
              path: AppRoutes.outboundEntry,
              redirect: (BuildContext context, GoRouterState state) =>
                  AppRoutes.newOutboundMovement,
            ),
            GoRoute(
              path: AppRoutes.warehouseReturn,
              builder: (BuildContext context, GoRouterState state) =>
                  const WarehouseReturnScreen(),
            ),
            GoRoute(
              path: AppRoutes.stockAdjustment,
              builder: (BuildContext context, GoRouterState state) {
                return BlocProvider<StocktakeCubit>(
                  create: (_) => createStocktakeCubit()..load(),
                  child: const StockAdjustmentScreen(),
                );
              },
            ),
            GoRoute(
              path: AppRoutes.transactionHistory,
              builder: (BuildContext context, GoRouterState state) =>
                  const TransactionHistoryScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
