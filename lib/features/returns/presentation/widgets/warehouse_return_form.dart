import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/shared_widgets/custom_button.dart';
import '../../../../core/shared_widgets/custom_text_field.dart';
import '../../data/models/warehouse_return_draft.dart';

class WarehouseReturnForm extends StatefulWidget {
  final ValueChanged<WarehouseReturnDraft>? onSubmit;

  const WarehouseReturnForm({super.key, this.onSubmit});

  @override
  State<WarehouseReturnForm> createState() => _WarehouseReturnFormState();
}

class _WarehouseReturnFormState extends State<WarehouseReturnForm> {
  final _voucherController = TextEditingController(text: 'OUT-1048');
  final _returnSourceController = TextEditingController(text: 'فرع مدينة نصر');
  final _itemNameController = TextEditingController(
    text: 'مناديل فاين 500 سحبة',
  );
  final _itemCodeController = TextEditingController(text: 'ITM-004');
  final _quantityController = TextEditingController(text: '5');
  final _returnedByController = TextEditingController(text: 'مسؤول الفرع');
  final _receivedByController = TextEditingController(text: 'أمين المخزن');
  final _dateController = TextEditingController(text: '2026-07-27');
  final _reasonController = TextEditingController(
    text: 'كمية زائدة عن احتياج الفرع',
  );
  final _notesController = TextEditingController();

  ReturnItemCondition _condition = ReturnItemCondition.needsInspection;

  @override
  void dispose() {
    _voucherController.dispose();
    _returnSourceController.dispose();
    _itemNameController.dispose();
    _itemCodeController.dispose();
    _quantityController.dispose();
    _returnedByController.dispose();
    _receivedByController.dispose();
    _dateController.dispose();
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitPreview() {
    final draft = WarehouseReturnDraft(
      originalVoucherNumber: _voucherController.text,
      returnSource: _returnSourceController.text,
      itemName: _itemNameController.text,
      itemCode: _itemCodeController.text,
      quantity: int.tryParse(_quantityController.text),
      returnedBy: _returnedByController.text,
      receivedBy: _receivedByController.text,
      returnDate: _dateController.text,
      reason: _reasonController.text,
      notes: _notesController.text,
      condition: _condition,
    );

    if (widget.onSubmit case final onSubmit?) {
      onSubmit(draft);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.returnUiOnlyMessage),
        backgroundColor: AppColors.info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('بيانات المرتجع', style: AppTextStyles.heading2),
            SizedBox(height: AppSizes.h4),
            Text(
              'سجّل بيانات الإذن والصنف وحالته قبل إضافته للمخزون.',
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: AppSizes.h20),
            _ResponsiveFieldRow(
              children: [
                CustomTextField(
                  label: AppStrings.originalVoucherNumber,
                  hint: 'مثال: OUT-1048',
                  controller: _voucherController,
                  prefixIcon: Icons.receipt_long_outlined,
                ),
                CustomTextField(
                  label: AppStrings.transactionDate,
                  controller: _dateController,
                  prefixIcon: Icons.calendar_today_outlined,
                ),
              ],
            ),
            SizedBox(height: AppSizes.h16),
            CustomTextField(
              label: AppStrings.returnSource,
              hint: 'اسم الفرع أو الجهة',
              controller: _returnSourceController,
              prefixIcon: Icons.storefront_outlined,
            ),
            SizedBox(height: AppSizes.h16),
            _ResponsiveFieldRow(
              children: [
                CustomTextField(
                  label: AppStrings.itemName,
                  controller: _itemNameController,
                  prefixIcon: Icons.inventory_2_outlined,
                ),
                CustomTextField(
                  label: AppStrings.itemCode,
                  controller: _itemCodeController,
                  prefixIcon: Icons.qr_code_2_rounded,
                ),
              ],
            ),
            SizedBox(height: AppSizes.h16),
            _ResponsiveFieldRow(
              children: [
                CustomTextField(
                  label: AppStrings.returnQuantity,
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.numbers_rounded,
                ),
                _ReturnConditionField(
                  value: _condition,
                  onChanged: (condition) {
                    if (condition != null) {
                      setState(() => _condition = condition);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: AppSizes.h16),
            _ResponsiveFieldRow(
              children: [
                CustomTextField(
                  label: AppStrings.returnedBy,
                  controller: _returnedByController,
                  prefixIcon: Icons.person_outline_rounded,
                ),
                CustomTextField(
                  label: AppStrings.receivedBy,
                  controller: _receivedByController,
                  prefixIcon: Icons.person_rounded,
                ),
              ],
            ),
            SizedBox(height: AppSizes.h16),
            CustomTextField(
              label: AppStrings.returnReason,
              controller: _reasonController,
              prefixIcon: Icons.assignment_return_outlined,
            ),
            SizedBox(height: AppSizes.h16),
            CustomTextField(
              label: AppStrings.notes,
              hint: 'ملاحظات عن حالة العبوة أو سبب الفحص...',
              controller: _notesController,
              prefixIcon: Icons.notes_rounded,
              maxLines: 3,
            ),
            SizedBox(height: AppSizes.h24),
            CustomButton(
              text: 'حفظ مسودة المرتجع',
              icon: Icons.save_outlined,
              backgroundColor: AppColors.secondary,
              onPressed: _submitPreview,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResponsiveFieldRow extends StatelessWidget {
  final List<Widget> children;

  const _ResponsiveFieldRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 560) {
          return Column(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index != children.length - 1)
                  SizedBox(height: AppSizes.h16),
              ],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < children.length; index++) ...[
              Expanded(child: children[index]),
              if (index != children.length - 1) SizedBox(width: AppSizes.p12),
            ],
          ],
        );
      },
    );
  }
}

class _ReturnConditionField extends StatelessWidget {
  final ReturnItemCondition value;
  final ValueChanged<ReturnItemCondition?> onChanged;

  const _ReturnConditionField({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.returnCondition,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: AppSizes.h8),
        DropdownButtonFormField<ReturnItemCondition>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.health_and_safety_outlined,
              color: _conditionColor(value),
            ),
          ),
          items: ReturnItemCondition.values
              .map(
                (condition) => DropdownMenuItem(
                  value: condition,
                  child: Text(
                    _conditionLabel(condition),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  String _conditionLabel(ReturnItemCondition condition) {
    return switch (condition) {
      ReturnItemCondition.readyForStock => 'صالح للإضافة للمخزون',
      ReturnItemCondition.damaged => 'تالف',
      ReturnItemCondition.needsInspection => 'يحتاج فحص',
    };
  }

  Color _conditionColor(ReturnItemCondition condition) {
    return switch (condition) {
      ReturnItemCondition.readyForStock => AppColors.success,
      ReturnItemCondition.damaged => AppColors.error,
      ReturnItemCondition.needsInspection => AppColors.warning,
    };
  }
}
