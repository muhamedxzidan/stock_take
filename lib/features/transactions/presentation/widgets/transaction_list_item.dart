import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/shared_widgets/pdf_voucher_dialog.dart';
import '../../../../core/shared_widgets/status_badge.dart';
import '../../data/models/transaction_model.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionListItem({super.key, required this.transaction});

  void _showPdfDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => PdfVoucherDialog(
        voucherType: transaction.type == TransactionType.inbound
            ? 'وارد'
            : transaction.type == TransactionType.outbound
                ? 'منصرف'
                : 'تسوية',
        voucherNumber: transaction.voucherNumber,
        date: transaction.date,
        partyName: transaction.partyName,
        deliveredBy: transaction.actorName,
        receivedBy: transaction.receiverName,
        itemName: transaction.itemName,
        quantity: transaction.quantity,
        unit: transaction.unit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(AppSizes.p12),
        onTap: () => _showPdfDialog(context),
        leading: _buildBadge(transaction.type),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(transaction.itemName, style: AppTextStyles.bodyLarge),
            ),
            Text(
              '${transaction.quantity > 0 ? "+${transaction.quantity}" : transaction.quantity} ${transaction.unit}',
              style: AppTextStyles.heading3.copyWith(
                color: transaction.type == TransactionType.inbound
                    ? AppColors.success
                    : transaction.type == TransactionType.outbound
                        ? AppColors.error
                        : AppColors.warning,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.h4),
            Text('الإذن: #${transaction.voucherNumber}  •  ${transaction.partyName}', style: AppTextStyles.bodyMedium),
            Text('من سلّم/صرف: ${transaction.actorName}  |  من استلم: ${transaction.receiverName}', style: AppTextStyles.caption),
            SizedBox(height: AppSizes.h4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(transaction.date, style: AppTextStyles.caption),
                const Icon(Icons.picture_as_pdf, color: AppColors.primary, size: 18),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(TransactionType type) {
    switch (type) {
      case TransactionType.inbound:
        return StatusBadge.inbound();
      case TransactionType.outbound:
        return StatusBadge.outbound();
      case TransactionType.adjustment:
        return StatusBadge.adjustment();
    }
  }
}
