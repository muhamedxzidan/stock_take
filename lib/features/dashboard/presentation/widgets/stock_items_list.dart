import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/inventory_item.dart';
import '../../cubit/dashboard_cubit.dart';
import '../../cubit/dashboard_state.dart';

class StockItemsList extends StatelessWidget {
  const StockItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      buildWhen: (previous, current) =>
          current is DashboardSuccess ||
          current is DashboardLoading ||
          current is DashboardFailure,
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DashboardFailure) {
          return Center(
            child: Text(state.message, style: AppTextStyles.bodyLarge),
          );
        }
        if (state is DashboardSuccess) {
          if (state.items.isEmpty) {
            return Center(
              child: Text(
                AppStrings.emptyList,
                style: AppTextStyles.bodyMedium,
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.items.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: AppSizes.h12),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return _buildItemCard(item);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildItemCard(InventoryItem item) {
    final bool isLowStock = item.currentStockBalance <= 30;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r12),
        side: BorderSide(
          color: isLowStock ? AppColors.error : AppColors.border,
          width: isLowStock ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: AppTextStyles.heading3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: AppSizes.p8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.p8,
                    vertical: AppSizes.p4,
                  ),
                  decoration: BoxDecoration(
                    color: isLowStock
                        ? AppColors.errorBackground
                        : AppColors.successBackground,
                    borderRadius: BorderRadius.circular(AppSizes.r8),
                  ),
                  child: Text(
                    isLowStock
                        ? AppStrings.lowStockWarning
                        : AppStrings.inStock,
                    style: AppTextStyles.caption.copyWith(
                      color: isLowStock ? AppColors.error : AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'الكود: ${item.code}',
                    style: AppTextStyles.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    'التعبئة: ${item.itemsPerCarton} قطعة/كرتونة',
                    textAlign: TextAlign.end,
                    style: AppTextStyles.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.divider, height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('الرصيد الإجمالي:', style: AppTextStyles.caption),
                      Text(
                        '${item.currentStockBalance} ${AppStrings.piecesCount}',
                        style: AppTextStyles.heading2.copyWith(
                          color: isLowStock
                              ? AppColors.error
                              : AppColors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    item.formattedCartonStock,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
