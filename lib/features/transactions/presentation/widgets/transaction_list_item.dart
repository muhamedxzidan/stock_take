import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/movement_record.dart';

class TransactionListItem extends StatelessWidget {
  final MovementRecord movement;

  const TransactionListItem({super.key, required this.movement});

  void _showDetails(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => _MovementRecordDetailsDialog(movement: movement),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(movement.type);
    return Card(
      key: Key('movement-record-${movement.id}'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(AppSizes.p12),
        onTap: () => _showDetails(context),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(_typeIcon(movement.type), color: color),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                movement.voucherNumber,
                style: AppTextStyles.heading3,
              ),
            ),
            Text(
              _quantityLabel(movement),
              style: AppTextStyles.heading3.copyWith(color: color),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.h4),
            Text(
              '${_typeLabel(movement.type)} • ${_itemsLabel(movement)}',
              style: AppTextStyles.bodyMedium,
            ),
            if (movement.partyName.isNotEmpty)
              Text(movement.partyName, style: AppTextStyles.caption),
            SizedBox(height: AppSizes.h4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(movement.businessAt),
                  style: AppTextStyles.caption,
                ),
                const Icon(
                  Icons.visibility_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _itemsLabel(MovementRecord movement) {
    if (movement.lines.isEmpty) {
      return 'بدون أصناف';
    }
    final first = movement.lines.first;
    if (movement.lines.length == 1) {
      return '${first.itemName} (${first.itemCode})';
    }
    return '${first.itemName} + ${movement.lines.length - 1} أصناف';
  }

  String _quantityLabel(MovementRecord movement) {
    final net = movement.netStockPieces;
    if (movement.type == MovementRecordType.supplierReplacement) {
      return 'صافي 0';
    }
    return '${net > 0 ? '+' : ''}$net قطعة';
  }
}

class _MovementRecordDetailsDialog extends StatelessWidget {
  final MovementRecord movement;

  const _MovementRecordDetailsDialog({required this.movement});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${_typeLabel(movement.type)} ${movement.voucherNumber}'),
      content: SizedBox(
        width: 620,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: AppSizes.p12,
                runSpacing: AppSizes.h8,
                children: [
                  _DetailText(
                    label: 'التاريخ',
                    value: _formatDate(movement.businessAt),
                  ),
                  if (movement.partyName.isNotEmpty)
                    _DetailText(label: 'الجهة', value: movement.partyName),
                  if (movement.deliveredBy.isNotEmpty)
                    _DetailText(
                      label: 'من سلّم/صرف',
                      value: movement.deliveredBy,
                    ),
                  if (movement.receivedBy.isNotEmpty)
                    _DetailText(label: 'من استلم', value: movement.receivedBy),
                ],
              ),
              SizedBox(height: AppSizes.h16),
              ...movement.lines.map(
                (line) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text(line.itemName),
                  subtitle: Text(
                    '${line.itemCode} • ${line.cartons} كرتونة + '
                    '${line.pieces} قطعة',
                  ),
                  trailing: Text('${line.totalPieces} قطعة'),
                ),
              ),
              if (movement.notes.isNotEmpty) ...[
                SizedBox(height: AppSizes.h12),
                Text('ملاحظات: ${movement.notes}'),
              ],
            ],
          ),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إغلاق'),
        ),
      ],
    );
  }
}

class _DetailText extends StatelessWidget {
  final String label;
  final String value;

  const _DetailText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p12,
        vertical: AppSizes.h8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: Text('$label: $value'),
    );
  }
}

String _typeLabel(MovementRecordType type) {
  return switch (type) {
    MovementRecordType.inbound => 'وارد',
    MovementRecordType.outbound => 'منصرف',
    MovementRecordType.customerReturn => 'مرتجع عميل',
    MovementRecordType.supplierReturn => 'مرتجع للمورد',
    MovementRecordType.supplierReplacement => 'استبدال مورد',
    MovementRecordType.stocktakeAdjustment => 'تسوية جرد',
  };
}

Color _typeColor(MovementRecordType type) {
  return switch (type) {
    MovementRecordType.inbound ||
    MovementRecordType.customerReturn => AppColors.success,
    MovementRecordType.outbound ||
    MovementRecordType.supplierReturn => AppColors.error,
    MovementRecordType.supplierReplacement => AppColors.secondary,
    MovementRecordType.stocktakeAdjustment => AppColors.warning,
  };
}

IconData _typeIcon(MovementRecordType type) {
  return switch (type) {
    MovementRecordType.inbound => Icons.south_west_rounded,
    MovementRecordType.outbound => Icons.north_east_rounded,
    MovementRecordType.customerReturn => Icons.assignment_return_rounded,
    MovementRecordType.supplierReturn => Icons.undo_rounded,
    MovementRecordType.supplierReplacement => Icons.swap_horiz_rounded,
    MovementRecordType.stocktakeAdjustment => Icons.fact_check_outlined,
  };
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
