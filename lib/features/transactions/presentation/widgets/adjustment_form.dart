import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/carton_piece_quantity.dart';
import '../../../../core/models/inventory_item.dart';
import '../../../../core/shared_widgets/carton_piece_quantity_fields.dart';
import '../../../../core/shared_widgets/custom_button.dart';
import '../../../../core/shared_widgets/custom_text_field.dart';
import '../../../items/presentation/widgets/inventory_item_selector_field.dart';
import '../../cubit/transactions_cubit.dart';
import '../../cubit/transactions_state.dart';

class AdjustmentForm extends StatefulWidget {
  const AdjustmentForm({super.key});

  @override
  State<AdjustmentForm> createState() => _AdjustmentFormState();
}

class _AdjustmentFormState extends State<AdjustmentForm> {
  final _reasonController = TextEditingController(
    text: 'عجز جردي نتيجة بضاعة تالفة',
  );
  bool _isSubmitting = false;
  InventoryItem? _selectedItem;
  CartonPieceQuantity _actualQuantity = const CartonPieceQuantity(
    cartons: 0,
    pieces: 0,
  );

  int get _calculatedDifference {
    final item = _selectedItem;
    if (item == null) {
      return 0;
    }
    return _actualQuantity.totalPiecesFor(item.itemsPerCarton) -
        item.currentStockPieces;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diff = _calculatedDifference;

    return BlocConsumer<TransactionsCubit, TransactionsState>(
      listenWhen: (prev, curr) =>
          curr is TransactionsSuccess || curr is TransactionsFailure,
      listener: (context, state) {
        if (!_isSubmitting) return;

        _isSubmitting = false;
        if (state is TransactionsSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.successSave),
              backgroundColor: AppColors.success,
            ),
          );
          // Navigate safely using GoRouter instead of Navigator.pop which breaks ShellRoute
          context.go(AppRoutes.transactionHistory);
          return;
        }

        if (state is TransactionsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is TransactionsLoading;
        return Column(
          children: [
            InventoryItemSelectorField(
              selectedItem: _selectedItem,
              onSelected: (item) => setState(() {
                _selectedItem = item;
                _actualQuantity = const CartonPieceQuantity(
                  cartons: 0,
                  pieces: 0,
                );
              }),
            ),
            SizedBox(height: AppSizes.h16),
            if (_selectedItem case final item?) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.p16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                ),
                child: Text(
                  'رصيد النظام: ${item.currentStockPieces} قطعة'
                  ' • ${item.formattedCartonStock}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h16),
              CartonPieceQuantityFields(
                key: ValueKey(item.id),
                keyPrefix: 'stocktake-actual',
                itemsPerCarton: item.itemsPerCarton,
                onChanged: (value) {
                  setState(() => _actualQuantity = value);
                },
              ),
              SizedBox(height: AppSizes.h16),
            ],
            Container(
              padding: EdgeInsets.all(AppSizes.p16),
              decoration: BoxDecoration(
                color: diff < 0
                    ? AppColors.errorBackground
                    : diff > 0
                    ? AppColors.successBackground
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSizes.r12),
                border: Border.all(
                  color: diff < 0 ? AppColors.error : AppColors.success,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      AppStrings.diffCount,
                      style: AppTextStyles.bodyLarge,
                    ),
                  ),
                  SizedBox(width: AppSizes.p8),
                  Text(
                    '${diff > 0 ? "+$diff" : "$diff"} قطعة',
                    style: AppTextStyles.heading2.copyWith(
                      color: diff < 0 ? AppColors.error : AppColors.success,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSizes.h16),
            CustomTextField(
              label: AppStrings.adjustmentReason,
              hint: 'سبب التعديل الجردي (مثال: بضاعة تالفة / رصيد افتتاحي خطأ)',
              controller: _reasonController,
              prefixIcon: Icons.note_alt,
            ),
            SizedBox(height: AppSizes.h32),
            CustomButton(
              text: AppStrings.save,
              backgroundColor: AppColors.warning,
              isLoading: isLoading,
              onPressed: () {
                final selectedItem = _selectedItem;
                if (selectedItem == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('اختر الصنف أولًا.'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                _isSubmitting = true;
                context.read<TransactionsCubit>().createAdjustmentTransaction(
                  itemName: selectedItem.name,
                  itemCode: selectedItem.code,
                  diffQuantity: diff,
                  reason: _reasonController.text,
                  date: DateTime.now().toIso8601String(),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
