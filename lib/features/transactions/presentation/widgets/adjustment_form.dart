import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/shared_widgets/custom_button.dart';
import '../../../../core/shared_widgets/custom_text_field.dart';
import '../../cubit/transactions_cubit.dart';
import '../../cubit/transactions_state.dart';

class AdjustmentForm extends StatefulWidget {
  const AdjustmentForm({super.key});

  @override
  State<AdjustmentForm> createState() => _AdjustmentFormState();
}

class _AdjustmentFormState extends State<AdjustmentForm> {
  final _itemNameController = TextEditingController(text: 'معجون أسنان سنسوداين 75مل');
  final _itemCodeController = TextEditingController(text: 'ITM-003');
  final _systemCountController = TextEditingController(text: '100');
  final _actualCountController = TextEditingController(text: '95');
  final _reasonController = TextEditingController(text: 'عجز جردي نتيجة بضاعة تالفة');

  int get _calculatedDifference {
    final sys = int.tryParse(_systemCountController.text) ?? 0;
    final act = int.tryParse(_actualCountController.text) ?? 0;
    return act - sys;
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemCodeController.dispose();
    _systemCountController.dispose();
    _actualCountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diff = _calculatedDifference;

    return BlocConsumer<TransactionsCubit, TransactionsState>(
      listenWhen: (prev, curr) => curr is TransactionsSuccess || curr is TransactionsFailure,
      listener: (context, state) {
        if (state is TransactionsSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.successSave),
              backgroundColor: AppColors.success,
            ),
          );
          // Navigate safely using GoRouter instead of Navigator.pop which breaks ShellRoute
          context.go(AppRoutes.transactionHistory);
        }
      },
      builder: (context, state) {
        final isLoading = state is TransactionsLoading;
        return Column(
          children: [
            CustomTextField(
              label: AppStrings.itemName,
              controller: _itemNameController,
              prefixIcon: Icons.inventory_2_outlined,
            ),
            SizedBox(height: AppSizes.h16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: AppStrings.systemCount,
                    keyboardType: TextInputType.number,
                    controller: _systemCountController,
                    onChanged: (_) => setState(() {}),
                    prefixIcon: Icons.computer,
                  ),
                ),
                SizedBox(width: AppSizes.p12),
                Expanded(
                  child: CustomTextField(
                    label: AppStrings.actualCount,
                    keyboardType: TextInputType.number,
                    controller: _actualCountController,
                    onChanged: (_) => setState(() {}),
                    prefixIcon: Icons.fact_check,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h16),

            // Diff preview indicator
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
                  Text(AppStrings.diffCount, style: AppTextStyles.bodyLarge),
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
                context.read<TransactionsCubit>().createAdjustmentTransaction(
                      itemName: _itemNameController.text,
                      itemCode: _itemCodeController.text,
                      diffQuantity: diff,
                      reason: _reasonController.text,
                      date: '2026-07-25',
                    );
              },
            ),
          ],
        );
      },
    );
  }
}
