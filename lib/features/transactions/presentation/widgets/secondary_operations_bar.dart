import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

class SecondaryOperationsBar extends StatelessWidget {
  final VoidCallback onWarehouseReturnTap;
  final VoidCallback onStocktakeTap;

  const SecondaryOperationsBar({
    super.key,
    required this.onWarehouseReturnTap,
    required this.onStocktakeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(AppStrings.otherOperations, style: AppTextStyles.heading3),
        SizedBox(height: AppSizes.h8),
        Row(
          children: [
            Expanded(
              child: _SecondaryOperationButton(
                buttonKey: const Key('open-warehouse-return'),
                title: AppStrings.warehouseReturn,
                subtitle: AppStrings.warehouseReturnHint,
                icon: Icons.assignment_return_rounded,
                color: AppColors.secondary,
                onTap: onWarehouseReturnTap,
              ),
            ),
            SizedBox(width: AppSizes.p8),
            Expanded(
              child: _SecondaryOperationButton(
                buttonKey: const Key('open-stocktake'),
                title: AppStrings.stocktake,
                subtitle: AppStrings.stocktakeHint,
                icon: Icons.fact_check_rounded,
                color: AppColors.warning,
                onTap: onStocktakeTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SecondaryOperationButton extends StatelessWidget {
  final Key buttonKey;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SecondaryOperationButton({
    required this.buttonKey,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      child: Material(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.r12),
        child: InkWell(
          key: buttonKey,
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.r12),
          child: Container(
            height: 68,
            padding: EdgeInsets.symmetric(horizontal: AppSizes.p12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.r12),
              border: Border.all(color: color.withValues(alpha: 0.32)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: AppSizes.iconMd),
                SizedBox(width: AppSizes.p8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppSizes.h4),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
