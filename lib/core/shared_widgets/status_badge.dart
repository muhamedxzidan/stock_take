import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color backgroundColor;

  const StatusBadge({
    super.key,
    required this.label,
    required this.textColor,
    required this.backgroundColor,
  });

  factory StatusBadge.inbound() {
    return const StatusBadge(
      label: 'وارد',
      textColor: AppColors.success,
      backgroundColor: AppColors.successBackground,
    );
  }

  factory StatusBadge.outbound() {
    return const StatusBadge(
      label: 'منصرف',
      textColor: AppColors.error,
      backgroundColor: AppColors.errorBackground,
    );
  }

  factory StatusBadge.adjustment() {
    return const StatusBadge(
      label: 'تسوية',
      textColor: AppColors.warning,
      backgroundColor: AppColors.warningBackground,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p12,
        vertical: AppSizes.p4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
