import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_styles.dart';

class PdfVoucherDialog extends StatelessWidget {
  final String voucherType; // 'وارد' or 'منصرف'
  final String voucherNumber;
  final String date;
  final String partyName; // Supplier or Recipient
  final String deliveredBy;
  final String receivedBy;
  final String driverName;
  final String itemName;
  final int quantity;
  final String unit;

  const PdfVoucherDialog({
    super.key,
    required this.voucherType,
    required this.voucherNumber,
    required this.date,
    required this.partyName,
    required this.deliveredBy,
    required this.receivedBy,
    this.driverName = '',
    required this.itemName,
    required this.quantity,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: EdgeInsets.all(AppSizes.p24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'إذن $voucherType رسمي',
                      style: AppTextStyles.heading1.copyWith(
                        color: AppColors.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '#$voucherNumber',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const Divider(color: AppColors.divider, height: 24),

              // Voucher Content
              _buildRow('المخزن:', AppStrings.singleWarehouseName),
              _buildRow('التاريخ:', date),
              _buildRow(
                voucherType == 'وارد' ? 'المورد:' : 'الجهة المستلمة:',
                partyName,
              ),
              _buildRow('من سلّم:', deliveredBy),
              _buildRow('من استلم / صرف:', receivedBy),
              if (driverName.trim().isNotEmpty)
                _buildRow('${AppStrings.driverName}:', driverName),

              SizedBox(height: AppSizes.h16),
              Container(
                padding: EdgeInsets.all(AppSizes.p12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppSizes.r8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        itemName,
                        style: AppTextStyles.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: AppSizes.p8),
                    Text(
                      '$quantity $unit',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSizes.h24),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: AppSizes.p12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('جاري إنشاء وطباعة ملف الـ PDF...'),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.picture_as_pdf,
                        color: AppColors.surface,
                      ),
                      label: FittedBox(
                        child: Text(
                          AppStrings.printPdf,
                          style: AppTextStyles.buttonText,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.p12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppStrings.cancel,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
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

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.h4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          SizedBox(width: AppSizes.p8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
