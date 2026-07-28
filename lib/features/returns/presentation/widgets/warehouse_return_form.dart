import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/carton_piece_quantity.dart';
import '../../../../core/models/inventory_item.dart';
import '../../../../core/shared_widgets/carton_piece_quantity_fields.dart';
import '../../../../core/shared_widgets/custom_button.dart';
import '../../../../core/shared_widgets/custom_text_field.dart';
import '../../../items/presentation/widgets/inventory_item_selector_field.dart';
import '../../cubit/returns_cubit.dart';
import '../../cubit/returns_state.dart';
import '../../data/models/warehouse_return_draft.dart';

class WarehouseReturnForm extends StatefulWidget {
  const WarehouseReturnForm({super.key});

  @override
  State<WarehouseReturnForm> createState() => _WarehouseReturnFormState();
}

class _WarehouseReturnFormState extends State<WarehouseReturnForm> {
  final _voucherController = TextEditingController();
  final _returnSourceController = TextEditingController();
  final _returnedByController = TextEditingController();
  final _receivedByController = TextEditingController();
  late final TextEditingController _dateController;
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();

  ReturnItemCondition _condition = ReturnItemCondition.needsInspection;
  InventoryItem? _selectedItem;
  CartonPieceQuantity _quantity = const CartonPieceQuantity(
    cartons: 0,
    pieces: 0,
  );

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateController = TextEditingController(
      text:
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
    );
  }

  @override
  void dispose() {
    _voucherController.dispose();
    _returnSourceController.dispose();
    _returnedByController.dispose();
    _receivedByController.dispose();
    _dateController.dispose();
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    final selectedItem = _selectedItem;
    if (selectedItem == null) {
      _showValidationMessage('اختر الصنف المرتجع.');
      return;
    }

    final totalPieces = _quantity.totalPiecesFor(selectedItem.itemsPerCarton);
    if (totalPieces <= 0) {
      _showValidationMessage('اكتب عدد الكراتين أو القطع.');
      return;
    }

    final receivedAt = DateTime.tryParse(_dateController.text.trim());
    if (receivedAt == null) {
      _showValidationMessage('اكتب التاريخ بصيغة صحيحة مثل 2026-07-28.');
      return;
    }

    final draft = WarehouseReturnDraft(
      originalVoucherNumber: _voucherController.text.trim(),
      sourceName: _returnSourceController.text.trim(),
      itemId: selectedItem.id,
      itemName: selectedItem.name,
      itemCode: selectedItem.code,
      quantityPieces: totalPieces,
      returnedBy: _returnedByController.text.trim(),
      receivedBy: _receivedByController.text.trim(),
      receivedAt: receivedAt,
      reason: _reasonController.text.trim(),
      notes: _notesController.text.trim(),
      condition: _condition,
    );

    context.read<ReturnsCubit>().createCustomerReturn(draft);
  }

  void _showValidationMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReturnsCubit, ReturnsState>(
      listenWhen: (previous, current) =>
          current is ReturnsSaved || current is ReturnsFailure,
      listener: (context, state) {
        if (state is ReturnsSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم حفظ المرتجع ${state.warehouseReturn.returnNumber} '
                'وزيادة رصيد ${state.warehouseReturn.itemCode} '
                'بمقدار ${state.warehouseReturn.quantityPieces} قطعة.',
              ),
              backgroundColor: AppColors.success,
            ),
          );
          setState(() {
            _selectedItem = null;
            _quantity = const CartonPieceQuantity(cartons: 0, pieces: 0);
            _voucherController.clear();
            _reasonController.clear();
            _notesController.clear();
          });
        } else if (state is ReturnsFailure) {
          _showValidationMessage(state.message);
        }
      },
      builder: (context, state) {
        final isSaving = state is ReturnsSaving;
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
                      fieldKey: const Key('return-original-voucher-field'),
                      label: AppStrings.originalVoucherNumber,
                      hint: 'مثال: OUT-1048',
                      controller: _voucherController,
                      prefixIcon: Icons.receipt_long_outlined,
                    ),
                    CustomTextField(
                      fieldKey: const Key('return-date-field'),
                      label: AppStrings.transactionDate,
                      controller: _dateController,
                      prefixIcon: Icons.calendar_today_outlined,
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.h16),
                CustomTextField(
                  fieldKey: const Key('return-source-field'),
                  label: AppStrings.returnSource,
                  hint: 'اسم الفرع أو الجهة',
                  controller: _returnSourceController,
                  prefixIcon: Icons.storefront_outlined,
                ),
                SizedBox(height: AppSizes.h16),
                InventoryItemSelectorField(
                  selectedItem: _selectedItem,
                  onSelected: (item) => setState(() {
                    _selectedItem = item;
                    _quantity = const CartonPieceQuantity(
                      cartons: 0,
                      pieces: 0,
                    );
                  }),
                ),
                SizedBox(height: AppSizes.h16),
                if (_selectedItem case final item?) ...[
                  CartonPieceQuantityFields(
                    key: ValueKey(item.id),
                    keyPrefix: 'return-quantity',
                    itemsPerCarton: item.itemsPerCarton,
                    onChanged: (value) => _quantity = value,
                  ),
                  SizedBox(height: AppSizes.h16),
                ],
                _ReturnConditionField(
                  value: _condition,
                  onChanged: (condition) {
                    if (condition != null) {
                      setState(() => _condition = condition);
                    }
                  },
                ),
                SizedBox(height: AppSizes.h16),
                _ResponsiveFieldRow(
                  children: [
                    CustomTextField(
                      fieldKey: const Key('return-returned-by-field'),
                      label: AppStrings.returnedBy,
                      controller: _returnedByController,
                      prefixIcon: Icons.person_outline_rounded,
                    ),
                    CustomTextField(
                      fieldKey: const Key('return-received-by-field'),
                      label: AppStrings.receivedBy,
                      controller: _receivedByController,
                      prefixIcon: Icons.person_rounded,
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.h16),
                CustomTextField(
                  fieldKey: const Key('return-reason-field'),
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
                  key: const Key('save-customer-return'),
                  text: 'حفظ المرتجع وإضافته للمخزون',
                  icon: Icons.assignment_turned_in_outlined,
                  backgroundColor: AppColors.secondary,
                  isLoading: isSaving,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        );
      },
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
