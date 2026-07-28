import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'movement_ui_types.dart';

class CurrentVoucherPanel extends StatelessWidget {
  final MovementKind movementKind;
  final List<MovementLineViewData> lines;
  final ValueChanged<MovementLineViewData> onEdit;
  final ValueChanged<MovementLineViewData> onRemove;
  final VoidCallback onContinue;

  const CurrentVoucherPanel({
    super.key,
    required this.movementKind,
    required this.lines,
    required this.onEdit,
    required this.onRemove,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final actionColor = movementKind == MovementKind.inbound
        ? AppColors.success
        : AppColors.error;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.p8),
                  decoration: BoxDecoration(
                    color: actionColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                  ),
                  child: Icon(Icons.receipt_long_outlined, color: actionColor),
                ),
                SizedBox(width: AppSizes.p12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('الإذن الحالي', style: AppTextStyles.heading2),
                      Text(
                        '${movementKind.label} • ${_itemCountLabel(lines.length)}',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h16),
            const Divider(height: 1, color: AppColors.divider),
            SizedBox(height: AppSizes.h12),
            Expanded(
              child: lines.isEmpty
                  ? const _EmptyVoucherState()
                  : ListView.separated(
                      itemCount: lines.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: AppSizes.h8),
                      itemBuilder: (context, index) {
                        final line = lines[index];
                        return _VoucherLineTile(
                          line: line,
                          onEdit: () => onEdit(line),
                          onRemove: () => onRemove(line),
                        );
                      },
                    ),
            ),
            SizedBox(height: AppSizes.h12),
            FilledButton.icon(
              key: const Key('voucher-continue'),
              style: FilledButton.styleFrom(
                backgroundColor: actionColor,
                minimumSize: Size(double.infinity, AppSizes.buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                ),
              ),
              onPressed: lines.isEmpty ? null : onContinue,
              icon: const Icon(Icons.arrow_back_rounded),
              label: Text(
                'استكمال ومراجعة الإذن',
                style: AppTextStyles.buttonText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _itemCountLabel(int count) {
    if (count == 1) return 'صنف واحد';
    if (count == 2) return 'صنفان';
    return '$count أصناف';
  }
}

class _VoucherLineTile extends StatelessWidget {
  final MovementLineViewData line;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _VoucherLineTile({
    required this.line,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.item.name,
                  style: AppTextStyles.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSizes.h4),
                Text(
                  '${line.quantityLabel} • ${line.totalPieces} قطعة',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'تعديل الكمية',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
          ),
          IconButton(
            tooltip: 'حذف الصنف',
            onPressed: onRemove,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyVoucherState extends StatelessWidget {
  const _EmptyVoucherState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.touch_app_outlined,
            color: AppColors.textLight,
            size: 48,
          ),
          SizedBox(height: AppSizes.h12),
          Text('اضغط على أي صنف لإضافته', style: AppTextStyles.bodyLarge),
          SizedBox(height: AppSizes.h4),
          Text('ستظهر الأصناف المختارة هنا.', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
