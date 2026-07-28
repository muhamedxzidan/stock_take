import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'movement_ui_types.dart';

class MovementTypeSelector extends StatelessWidget {
  final MovementKind selectedKind;
  final ValueChanged<MovementKind> onChanged;

  const MovementTypeSelector({
    super.key,
    required this.selectedKind,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p12),
        child: Row(
          children: [
            Expanded(
              child: _MovementTypeButton(
                key: const Key('movement-type-inbound'),
                label: 'وارد +',
                subtitle: 'إضافة للمخزن',
                icon: Icons.south_west_rounded,
                color: AppColors.success,
                backgroundColor: AppColors.successBackground,
                selected: selectedKind == MovementKind.inbound,
                onTap: () => onChanged(MovementKind.inbound),
              ),
            ),
            SizedBox(width: AppSizes.p12),
            Expanded(
              child: _MovementTypeButton(
                key: const Key('movement-type-outbound'),
                label: 'منصرف −',
                subtitle: 'خصم من المخزن',
                icon: Icons.north_east_rounded,
                color: AppColors.error,
                backgroundColor: AppColors.errorBackground,
                selected: selectedKind == MovementKind.outbound,
                onTap: () => onChanged(MovementKind.outbound),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovementTypeButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final bool selected;
  final VoidCallback onTap;

  const _MovementTypeButton({
    super.key,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? backgroundColor : AppColors.surface,
      borderRadius: BorderRadius.circular(AppSizes.r12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.p12,
            vertical: AppSizes.p12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.r12),
            border: Border.all(
              color: selected ? color : AppColors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: AppSizes.iconMd),
              SizedBox(width: AppSizes.p8),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.heading2.copyWith(color: color),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(color: color),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
