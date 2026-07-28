import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'movement_ui_types.dart';

class MovementVoucherPreviewDialog extends StatelessWidget {
  final MovementKind movementKind;
  final List<MovementLineViewData> lines;
  final MovementVoucherDetails details;

  const MovementVoucherPreviewDialog({
    super.key,
    required this.movementKind,
    required this.lines,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final actionColor = movementKind == MovementKind.inbound
        ? AppColors.success
        : AppColors.error;
    final totalPieces = lines.fold<int>(
      0,
      (sum, line) => sum + line.totalPieces,
    );

    return Dialog(
      insetPadding: EdgeInsets.all(AppSizes.p16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 720),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.p20),
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
                    child: Icon(
                      Icons.receipt_long_outlined,
                      color: actionColor,
                    ),
                  ),
                  SizedBox(width: AppSizes.p12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'معاينة إذن ${movementKind.label}',
                          style: AppTextStyles.heading1,
                        ),
                        Text(
                          '${lines.length} أصناف • $totalPieces قطعة إجمالي',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'إغلاق',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.h16),
              Container(
                padding: EdgeInsets.all(AppSizes.p12),
                decoration: BoxDecoration(
                  color: AppColors.infoBackground,
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.info,
                    ),
                    SizedBox(width: AppSizes.p8),
                    Expanded(
                      child: Text(
                        'هذه معاينة UI فقط؛ لن يتم حفظ البيانات أو تعديل الرصيد.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.h16),
              Wrap(
                spacing: AppSizes.p16,
                runSpacing: AppSizes.h8,
                children: [
                  _DetailChip(
                    label: movementKind == MovementKind.inbound
                        ? 'المورد'
                        : 'الجهة المستلمة',
                    value: details.partyName,
                  ),
                  _DetailChip(label: 'التاريخ', value: details.date),
                  if (details.deliveredBy.isNotEmpty)
                    _DetailChip(label: 'من سلّم', value: details.deliveredBy),
                  if (details.receivedBy.isNotEmpty)
                    _DetailChip(label: 'من استلم', value: details.receivedBy),
                  if (details.driverName.isNotEmpty)
                    _DetailChip(
                      label: AppStrings.driverName,
                      value: details.driverName,
                    ),
                ],
              ),
              SizedBox(height: AppSizes.h16),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                    child: SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            AppColors.surfaceVariant,
                          ),
                          columns: const [
                            DataColumn(label: Text('الصنف')),
                            DataColumn(numeric: true, label: Text('كرتونة')),
                            DataColumn(numeric: true, label: Text('قطع')),
                            DataColumn(numeric: true, label: Text('الإجمالي')),
                          ],
                          rows: lines
                              .map(
                                (line) => DataRow(
                                  cells: [
                                    DataCell(
                                      SizedBox(
                                        width: 220,
                                        child: Text(
                                          line.item.name,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    DataCell(Text('${line.cartons}')),
                                    DataCell(Text('${line.pieces}')),
                                    DataCell(Text('${line.totalPieces}')),
                                  ],
                                ),
                              )
                              .toList(growable: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (details.notes.isNotEmpty) ...[
                SizedBox(height: AppSizes.h12),
                Text(
                  'ملاحظات: ${details.notes}',
                  style: AppTextStyles.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: AppSizes.h16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      key: const Key('voucher-ui-finish'),
                      style: FilledButton.styleFrom(
                        backgroundColor: actionColor,
                        minimumSize: Size(
                          double.infinity,
                          AppSizes.buttonHeight,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.r12),
                        ),
                      ),
                      onPressed: () {
                        final messenger = ScaffoldMessenger.of(context);
                        Navigator.pop(context);
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text(
                              'تمت معاينة الحفظ والطباعة كواجهة فقط.',
                            ),
                            backgroundColor: AppColors.info,
                          ),
                        );
                      },
                      icon: const Icon(Icons.print_outlined),
                      label: Text(
                        'حفظ وطباعة',
                        style: AppTextStyles.buttonText,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.p12),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('رجوع للتعديل'),
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

class _DetailChip extends StatelessWidget {
  final String label;
  final String value;

  const _DetailChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p12,
        vertical: AppSizes.p8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.r24),
      ),
      child: Text(
        '$label: $value',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
