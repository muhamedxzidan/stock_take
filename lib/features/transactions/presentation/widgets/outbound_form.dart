import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/shared_widgets/custom_button.dart';
import '../../../../core/shared_widgets/custom_text_field.dart';
import '../../../../core/shared_widgets/pdf_voucher_dialog.dart';
import '../../cubit/transactions_cubit.dart';
import '../../cubit/transactions_state.dart';

class OutboundForm extends StatefulWidget {
  const OutboundForm({super.key});

  @override
  State<OutboundForm> createState() => _OutboundFormState();
}

class _OutboundFormState extends State<OutboundForm> {
  final _recipientController = TextEditingController();
  final _dispatchedByController = TextEditingController();
  final _receivedByController = TextEditingController();
  final _driverNameController = TextEditingController();
  final _itemNameController = TextEditingController(
    text: 'مناديل فاين 500 سحبة',
  );
  final _itemCodeController = TextEditingController(text: 'ITM-004');
  final _quantityController = TextEditingController(text: '20');
  final _dateController = TextEditingController(text: '2026-07-25');

  @override
  void dispose() {
    _recipientController.dispose();
    _dispatchedByController.dispose();
    _receivedByController.dispose();
    _driverNameController.dispose();
    _itemNameController.dispose();
    _itemCodeController.dispose();
    _quantityController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _showPdfPreview() {
    showDialog(
      context: context,
      builder: (ctx) => PdfVoucherDialog(
        voucherType: 'منصرف',
        voucherNumber: 'OUT-${DateTime.now().millisecond}',
        date: _dateController.text,
        partyName: _recipientController.text.isEmpty
            ? 'فرع الجيزة'
            : _recipientController.text,
        deliveredBy: _dispatchedByController.text.isEmpty
            ? 'أمين المخزن'
            : _dispatchedByController.text,
        receivedBy: _receivedByController.text.isEmpty
            ? 'مستلم الفرع'
            : _receivedByController.text,
        driverName: _driverNameController.text,
        itemName: _itemNameController.text,
        quantity: int.tryParse(_quantityController.text) ?? 20,
        unit: 'علبة',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionsCubit, TransactionsState>(
      listenWhen: (prev, curr) =>
          curr is TransactionsSuccess || curr is TransactionsFailure,
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
              label: AppStrings.recipientEntity,
              hint: 'الفرع أو القسم المستلم',
              controller: _recipientController,
              prefixIcon: Icons.store,
            ),
            SizedBox(height: AppSizes.h16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: AppStrings.dispatchedBy,
                    hint: 'اسم من صرف',
                    controller: _dispatchedByController,
                    prefixIcon: Icons.person_outline,
                  ),
                ),
                SizedBox(width: AppSizes.p12),
                Expanded(
                  child: CustomTextField(
                    label: AppStrings.receivedBy,
                    hint: 'اسم المستلم الفعلي',
                    controller: _receivedByController,
                    prefixIcon: Icons.person,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h16),
            CustomTextField(
              label: AppStrings.driverName,
              hint: 'اسم سائق سيارة التسليم',
              controller: _driverNameController,
              prefixIcon: Icons.local_shipping_outlined,
            ),
            SizedBox(height: AppSizes.h16),
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
                    label: AppStrings.quantityPieces,
                    keyboardType: TextInputType.number,
                    controller: _quantityController,
                    prefixIcon: Icons.numbers,
                  ),
                ),
                SizedBox(width: AppSizes.p12),
                Expanded(
                  child: CustomTextField(
                    label: AppStrings.transactionDate,
                    controller: _dateController,
                    prefixIcon: Icons.calendar_today,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h24),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, AppSizes.buttonHeight),
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                ),
              ),
              onPressed: _showPdfPreview,
              icon: const Icon(Icons.picture_as_pdf, color: AppColors.error),
              label: const Text('معاينة وطباعة إذن المنصرف PDF'),
            ),
            SizedBox(height: AppSizes.h16),
            CustomButton(
              text: AppStrings.save,
              backgroundColor: AppColors.error,
              isLoading: isLoading,
              onPressed: () {
                context.read<TransactionsCubit>().createOutboundTransaction(
                  itemName: _itemNameController.text,
                  itemCode: _itemCodeController.text,
                  quantity: int.tryParse(_quantityController.text) ?? 0,
                  recipientEntity: _recipientController.text,
                  dispatchedBy: _dispatchedByController.text,
                  receivedBy: _receivedByController.text,
                  date: _dateController.text,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
