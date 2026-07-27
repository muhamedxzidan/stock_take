import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/items/presentation/screens/add_item_screen.dart';
import '../../features/returns/presentation/screens/warehouse_return_screen.dart';
import '../../features/transactions/presentation/screens/inbound_entry_screen.dart';
import '../../features/transactions/presentation/screens/outbound_entry_screen.dart';
import '../../features/transactions/presentation/screens/stock_adjustment_screen.dart';
import '../../features/transactions/presentation/screens/transaction_history_screen.dart';
import '../shared_widgets/main_shell_screen.dart';
import 'app_routes.dart';

/// AppRouter configures GoRouter with a persistent ShellRoute for Tablet & Mobile navigation.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return MainShellScreen(state: state, child: child);
        },
        routes: [
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
            builder: (BuildContext context, GoRouterState state) =>
                const InboundEntryScreen(),
          ),
          GoRoute(
            path: AppRoutes.outboundEntry,
            builder: (BuildContext context, GoRouterState state) =>
                const OutboundEntryScreen(),
          ),
          GoRoute(
            path: AppRoutes.warehouseReturn,
            builder: (BuildContext context, GoRouterState state) =>
                const WarehouseReturnScreen(),
          ),
          GoRoute(
            path: AppRoutes.stockAdjustment,
            builder: (BuildContext context, GoRouterState state) =>
                const StockAdjustmentScreen(),
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
