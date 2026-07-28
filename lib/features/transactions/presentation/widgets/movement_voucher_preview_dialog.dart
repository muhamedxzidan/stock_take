import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../cubit/transactions_cubit.dart';
import '../../cubit/transactions_state.dart';
import '../../data/models/inventory_movement.dart';
import 'movement_ui_types.dart';

class MovementVoucherPreviewDialog extends StatefulWidget {
  final MovementKind movementKind;
  final List<MovementLineViewData> lines;
  final MovementVoucherDetails details;
  final InventoryMovementDraft movementDraft;

  const MovementVoucherPreviewDialog({
    super.key,
    required this.movementKind,
    required this.lines,
    required this.details,
    required this.movementDraft,
  });

  @override
  State<MovementVoucherPreviewDialog> createState() =>
      _MovementVoucherPreviewDialogState();
}

class _MovementVoucherPreviewDialogState
    extends State<MovementVoucherPreviewDialog> {
  bool _isSaving = false;

  Future<void> _confirm() async {
    setState(() => _isSaving = true);
    final cubit = context.read<TransactionsCubit>();
    final movement = widget.movementKind == MovementKind.inbound
        ? await cubit.createInboundMovement(widget.movementDraft)
        : await cubit.createOutboundMovement(widget.movementDraft);
    if (!mounted) return;

    if (movement == null) {
      final state = cubit.state;
      final message = state is InventoryMovementFailure
          ? state.message
          : 'تعذر حفظ إذن ${widget.movementKind.voucherLabel} الآن.';
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.error),
      );
      return;
    }

    Navigator.pop(context, movement);
  }

  @override
  Widget build(BuildContext context) {
    final actionColor = widget.movementKind == MovementKind.inbound
        ? AppColors.success
        : AppColors.error;
    final totalPieces = widget.lines.fold<int>(
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
                          'معاينة إذن ${widget.movementKind.label}',
                          style: AppTextStyles.heading1,
                        ),
                        Text(
                          '${widget.lines.length} أصناف • $totalPieces قطعة إجمالي',
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
                        'عند التأكيد سيُحفظ إذن '
                        '${widget.movementKind.voucherLabel} '
                        'وتُحدّث الأرصدة معًا.',
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
                    label: widget.movementKind == MovementKind.inbound
                        ? 'المورد'
                        : 'الجهة المستلمة',
                    value: widget.details.partyName,
                  ),
                  _DetailChip(label: 'التاريخ', value: widget.details.date),
                  if (widget.details.deliveredBy.isNotEmpty)
                    _DetailChip(
                      label: 'من سلّم',
                      value: widget.details.deliveredBy,
                    ),
                  if (widget.details.receivedBy.isNotEmpty)
                    _DetailChip(
                      label: 'من استلم',
                      value: widget.details.receivedBy,
                    ),
                  if (widget.details.driverName.isNotEmpty)
                    _DetailChip(
                      label: AppStrings.driverName,
                      value: widget.details.driverName,
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
                            DataColumn(label: Text('كود الصنف')),
                            DataColumn(numeric: true, label: Text('كرتونة')),
                            DataColumn(numeric: true, label: Text('قطع')),
                            DataColumn(numeric: true, label: Text('الإجمالي')),
                          ],
                          rows: widget.lines
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
                                    DataCell(
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          line.item.code,
                                          key: Key(
                                            'voucher-item-code-${line.item.id}',
                                          ),
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
              if (widget.details.notes.isNotEmpty) ...[
                SizedBox(height: AppSizes.h12),
                Text(
                  'ملاحظات: ${widget.details.notes}',
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
                      onPressed: _isSaving ? null : _confirm,
                      icon: _isSaving
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.surface,
                              ),
                            )
                          : const Icon(Icons.save_rounded),
                      label: Text(
                        'حفظ ${widget.movementKind.voucherLabel}',
                        style: AppTextStyles.buttonText,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.p12),
                  OutlinedButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
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
