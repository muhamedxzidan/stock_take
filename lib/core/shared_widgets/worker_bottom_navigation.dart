import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../constants/app_strings.dart';

class WorkerBottomNavigation extends StatelessWidget {
  final String currentRoute;
  final VoidCallback onLogout;

  const WorkerBottomNavigation({
    super.key,
    required this.currentRoute,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final routes = [
      AppRoutes.newMovement,
      AppRoutes.dashboard,
      AppRoutes.transactionHistory,
    ];
    final effectiveRoute = _isSecondaryMovementRoute(currentRoute)
        ? AppRoutes.newMovement
        : currentRoute;
    final selectedIndex = routes.indexOf(effectiveRoute);

    return Row(
      children: [
        Expanded(
          child: NavigationBar(
            selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
            onDestinationSelected: (index) {
              final route = routes[index];
              if (route != currentRoute) context.go(route);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.add_box_outlined),
                selectedIcon: Icon(Icons.add_box_rounded),
                label: 'حركة جديدة',
              ),
              NavigationDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2_rounded),
                label: 'رصيد المخزن',
              ),
              NavigationDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history_rounded),
                label: 'سجل الحركات',
              ),
            ],
          ),
        ),
        Material(
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: SizedBox(
            height: 80,
            width: 56,
            child: IconButton(
              tooltip: AppStrings.logout,
              onPressed: onLogout,
              icon: const Icon(Icons.logout_rounded),
            ),
          ),
        ),
      ],
    );
  }

  bool _isSecondaryMovementRoute(String route) {
    return route == AppRoutes.warehouseReturn ||
        route == AppRoutes.stockAdjustment;
  }
}
