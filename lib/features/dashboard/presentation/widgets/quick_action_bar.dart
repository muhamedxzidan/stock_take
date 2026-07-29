import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

class QuickActionBar extends StatelessWidget {
  const QuickActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    const actions = [
      _QuickAction(
        title: 'إضافة صنف',
        icon: Icons.add_box,
        color: AppColors.primary,
        route: AppRoutes.addItem,
      ),
      _QuickAction(
        title: 'وارد جديد',
        icon: Icons.input,
        color: AppColors.success,
        route: AppRoutes.newInboundMovement,
      ),
      _QuickAction(
        title: 'منصرف جديد',
        icon: Icons.output,
        color: AppColors.error,
        route: AppRoutes.newOutboundMovement,
      ),
      _QuickAction(
        title: 'مرتجع',
        icon: Icons.assignment_return_rounded,
        color: AppColors.secondary,
        route: AppRoutes.warehouseReturn,
      ),
      _QuickAction(
        title: 'تسوية جرد',
        icon: Icons.inventory_2,
        color: AppColors.warning,
        route: AppRoutes.stockAdjustment,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 700
            ? 5
            : constraints.maxWidth >= 440
            ? 3
            : 2;
        final gap = AppSizes.p8;
        final itemWidth =
            (constraints.maxWidth - (gap * (columns - 1))) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: actions
              .map(
                (action) => SizedBox(
                  width: itemWidth,
                  child: _buildActionButton(context, action: action),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required _QuickAction action,
  }) {
    return InkWell(
      onTap: () => context.go(action.route),
      borderRadius: BorderRadius.circular(AppSizes.r12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p8,
          vertical: AppSizes.p12,
        ),
        decoration: BoxDecoration(
          color: action.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.r12),
          border: Border.all(color: action.color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(action.icon, color: action.color, size: 22),
            SizedBox(height: AppSizes.h4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                action.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: action.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  const _QuickAction({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
  });
}
