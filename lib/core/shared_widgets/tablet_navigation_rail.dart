import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_sizes.dart';

class TabletNavigationRail extends StatelessWidget {
  final String currentRoute;
  final VoidCallback onLogout;

  const TabletNavigationRail({
    super.key,
    required this.currentRoute,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: AppColors.primary,
      child: Column(
        children: [
          SizedBox(height: AppSizes.h32),
          // App Logo / Title Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warehouse_rounded,
                color: AppColors.surface,
                size: 28,
              ),
              SizedBox(width: AppSizes.p8),
              const Flexible(
                child: Text(
                  'إدارة المخزون',
                  style: TextStyle(
                    color: AppColors.surface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h32),
          const Divider(color: Colors.white24, height: 1),
          SizedBox(height: AppSizes.h16),

          // Scrollable Nav Items list to prevent vertical overflow on smaller screens
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildNavItem(
                    context,
                    title: 'حركة جديدة',
                    icon: Icons.add_box_rounded,
                    route: AppRoutes.newMovement,
                  ),
                  _buildNavItem(
                    context,
                    title: 'رصيد المخزن',
                    icon: Icons.inventory_2_rounded,
                    route: AppRoutes.dashboard,
                  ),
                  _buildNavItem(
                    context,
                    title: 'سجل الحركات',
                    icon: Icons.history_rounded,
                    route: AppRoutes.transactionHistory,
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Material(
              color: Colors.transparent,
              child: ListTile(
                onTap: onLogout,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                ),
                leading: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.surface,
                ),
                title: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(color: AppColors.surface),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'المخزن الرئيسي v1.0',
              style: TextStyle(
                color: AppColors.surface.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    final isSelected =
        currentRoute == route ||
        (route == AppRoutes.newMovement &&
            _isSecondaryMovementRoute(currentRoute));

    // Use fixed horizontal padding (8.0, 12.0) inside fixed 220px container to prevent overflow on wide screens
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (currentRoute != route) {
              context.go(route);
            }
          },
          borderRadius: BorderRadius.circular(AppSizes.r12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.surface.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSizes.r12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppColors.surface
                      : AppColors.surface.withValues(alpha: 0.7),
                  size: 22,
                ),
                const SizedBox(width: 10.0),
                // Wrap text in Expanded with ellipsis to prevent horizontal row overflow
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.surface
                          : AppColors.surface.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isSecondaryMovementRoute(String route) {
    return route == AppRoutes.warehouseReturn ||
        route == AppRoutes.stockAdjustment;
  }
}
