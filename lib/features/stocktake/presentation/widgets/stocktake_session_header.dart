import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/stocktake_session.dart';

/// Displays immutable session metadata and the current counting progress.
class StocktakeSessionHeader extends StatelessWidget {
  final StocktakeSession session;
  final int countedItems;
  final int totalItems;
  final int netDifference;

  const StocktakeSessionHeader({
    super.key,
    required this.session,
    required this.countedItems,
    required this.totalItems,
    required this.netDifference,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.infoBackground,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: AppColors.info),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(session.stocktakeNumber, style: AppTextStyles.heading2),
          SizedBox(height: AppSizes.h4),
          Text(
            'الفترة: ${_formatDate(session.periodFrom)} — '
            '${_formatDate(session.periodTo)}',
            style: AppTextStyles.bodyMedium,
          ),
          SizedBox(height: AppSizes.h8),
          Wrap(
            spacing: AppSizes.p16,
            runSpacing: AppSizes.h8,
            children: [
              Text(
                'التقدم: $countedItems / $totalItems',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'صافي الفرق الحالي: ${netDifference > 0 ? '+' : ''}'
                '$netDifference قطعة',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: netDifference < 0
                      ? AppColors.error
                      : AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
