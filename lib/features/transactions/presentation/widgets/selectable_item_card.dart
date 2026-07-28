import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/inventory_item.dart';
import 'movement_ui_types.dart';

class SelectableItemCard extends StatelessWidget {
  final InventoryItem item;
  final MovementLineViewData? selectedLine;
  final VoidCallback onTap;

  const SelectableItemCard({
    super.key,
    required this.item,
    required this.selectedLine,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedLine != null;

    return Card(
      elevation: isSelected ? 2 : 0,
      margin: EdgeInsets.zero,
      color: isSelected ? AppColors.infoBackground : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
        side: BorderSide(
          color: isSelected ? AppColors.primaryLight : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: Key('movement-item-${item.id}'),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSizes.p8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppSizes.r12),
                    ),
                    child: Icon(
                      isSelected
                          ? Icons.check_rounded
                          : Icons.inventory_2_outlined,
                      color: isSelected ? AppColors.surface : AppColors.primary,
                      size: AppSizes.iconMd,
                    ),
                  ),
                  SizedBox(width: AppSizes.p12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: AppTextStyles.heading3,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: AppSizes.h4),
                        Text(
                          '${item.code} • ${item.itemsPerCarton} قطعة/كرتونة',
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.h16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الرصيد الحالي', style: AppTextStyles.caption),
                        Text(
                          item.formattedCartonStock,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.p8,
                        vertical: AppSizes.p4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSizes.r24),
                      ),
                      child: Text(
                        selectedLine!.quantityLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
