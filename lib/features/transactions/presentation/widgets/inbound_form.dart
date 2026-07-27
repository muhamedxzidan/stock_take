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

class InboundForm extends StatefulWidget {
  const InboundForm({super.key});

  @override
  State<InboundForm> createState() => _InboundFormState();
}

class _InboundFormState extends State<InboundForm> {
  final _supplierController = TextEditingController();
  final _deliveredByController = TextEditingController();
  final _receivedByController = TextEditingController();
  final _driverNameController = TextEditingController();
  final _itemNameController = TextEditingController(
    text: 'شامبو لوريال 400 مل',
  );
  final _itemCodeController = TextEditingController(text: 'ITM-001');
  final _quantityController = TextEditingController(text: '50');
  final _dateController = TextEditingController(text: '2026-07-25');

  @override
  void dispose() {
    _supplierController.dispose();
    _deliveredByController.dispose();
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
        voucherType: 'وارد',
        voucherNumber: 'INV-${DateTime.now().millisecond}',
        date: _dateController.text,
        partyName: _supplierController.text.isEmpty
            ? 'شركة التوريدات الحديثة'
            : _supplierController.text,
        deliveredBy: _deliveredByController.text.isEmpty
            ? 'مندوب المورد'
            : _deliveredByController.text,
        receivedBy: _receivedByController.text.isEmpty
            ? 'أمين المخزن'
            : _receivedByController.text,
        driverName: _driverNameController.text,
        itemName: _itemNameController.text,
        quantity: int.tryParse(_quantityController.text) ?? 50,
        unit: 'قطعة',
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
              label: AppStrings.supplierName,
              hint: 'اسم الشركة الموردة',
              controller: _supplierController,
              prefixIcon: Icons.business,
            ),
            SizedBox(height: AppSizes.h16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: AppStrings.deliveredBy,
                    hint: 'اسم المندوب',
                    controller: _deliveredByController,
                    prefixIcon: Icons.person_outline,
                  ),
                ),
                SizedBox(width: AppSizes.p12),
                Expanded(
                  child: CustomTextField(
                    label: AppStrings.receivedBy,
                    hint: 'اسم أمين المخزن',
                    controller: _receivedByController,
                    prefixIcon: Icons.person,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h16),
            CustomTextField(
              label: AppStrings.driverName,
              hint: 'اسم سائق سيارة التوريد',
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
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                ),
              ),
              onPressed: _showPdfPreview,
              icon: const Icon(Icons.picture_as_pdf, color: AppColors.primary),
              label: const Text('معاينة وطباعة إذن الوارد PDF'),
            ),
            SizedBox(height: AppSizes.h16),
            CustomButton(
              text: AppStrings.save,
              backgroundColor: AppColors.success,
              isLoading: isLoading,
              onPressed: () {
                context.read<TransactionsCubit>().createInboundTransaction(
                  itemName: _itemNameController.text,
                  itemCode: _itemCodeController.text,
                  quantity: int.tryParse(_quantityController.text) ?? 0,
                  supplierName: _supplierController.text,
                  deliveredBy: _deliveredByController.text,
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
