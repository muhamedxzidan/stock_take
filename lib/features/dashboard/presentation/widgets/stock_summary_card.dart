import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/stock_summary_model.dart';

class StockSummaryCard extends StatelessWidget {
  final StockSummaryModel summary;

  const StockSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  AppStrings.singleWarehouseName,
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.surface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.warehouse, color: AppColors.surface),
            ],
          ),
          SizedBox(height: AppSizes.h16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _buildStatItem(
                  'إجمالي الأصناف',
                  '${summary.totalItemsCount}',
                  Icons.category,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  AppStrings.totalInbound,
                  '${summary.totalInboundCount}',
                  Icons.arrow_downward,
                  color: AppColors.success,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  AppStrings.totalOutbound,
                  '${summary.totalOutboundCount}',
                  Icons.arrow_upward,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color ?? AppColors.surface.withValues(alpha: 0.8),
          size: AppSizes.iconMd,
        ),
        SizedBox(height: AppSizes.h4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: AppTextStyles.heading2.copyWith(color: AppColors.surface),
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.surface.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }
}
