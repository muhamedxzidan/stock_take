import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
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
  final _returnSourceController = TextEditingController();

  InventoryItem? _selectedItem;
  CartonPieceQuantity _quantity = const CartonPieceQuantity(
    cartons: 0,
    pieces: 0,
  );

  @override
  void dispose() {
    _returnSourceController.dispose();
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

    if (_returnSourceController.text.trim().isEmpty) {
      _showValidationMessage('اكتب المرتجع من مين.');
      return;
    }

    final draft = WarehouseReturnDraft(
      sourceName: _returnSourceController.text.trim(),
      itemId: selectedItem.id,
      itemName: selectedItem.name,
      itemCode: selectedItem.code,
      quantityPieces: totalPieces,
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
                'وإضافته لرصيد ${state.warehouseReturn.itemCode}.',
              ),
              backgroundColor: AppColors.success,
            ),
          );
          setState(() {
            _selectedItem = null;
            _quantity = const CartonPieceQuantity(cartons: 0, pieces: 0);
            _returnSourceController.clear();
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
                  'اختر الصنف، اكتب المرتجع من مين والكمية فقط.',
                  style: AppTextStyles.bodyMedium,
                ),
                SizedBox(height: AppSizes.h20),
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
                if (_selectedItem case final item?) ...[
                  SizedBox(height: AppSizes.h12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSizes.p12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppSizes.r12),
                    ),
                    child: Text(
                      'كود الصنف: ${item.code}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
                SizedBox(height: AppSizes.h16),
                CustomTextField(
                  fieldKey: const Key('return-source-field'),
                  label: 'المرتجع من مين',
                  hint: 'اسم الشخص أو الفرع أو الجهة',
                  controller: _returnSourceController,
                  prefixIcon: Icons.person_pin_circle_outlined,
                  enabled: !isSaving,
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
                SizedBox(height: AppSizes.h8),
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
