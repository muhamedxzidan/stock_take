import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/carton_piece_quantity.dart';
import '../../../../core/models/inventory_item.dart';
import '../../../../core/shared_widgets/carton_piece_quantity_fields.dart';
import '../../../../core/shared_widgets/custom_button.dart';
import '../../../../core/shared_widgets/custom_text_field.dart';
import '../../../../core/shared_widgets/pdf_voucher_dialog.dart';
import '../../../items/presentation/widgets/inventory_item_selector_field.dart';
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
  final _dateController = TextEditingController(text: '2026-07-25');
  InventoryItem? _selectedItem;
  CartonPieceQuantity _quantity = const CartonPieceQuantity(
    cartons: 0,
    pieces: 0,
  );

  @override
  void dispose() {
    _recipientController.dispose();
    _dispatchedByController.dispose();
    _receivedByController.dispose();
    _driverNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _showPdfPreview() {
    final selectedItem = _selectedItem;
    if (selectedItem == null) {
      _showValidationMessage('اختر الصنف أولًا.');
      return;
    }
    final totalPieces = _quantity.totalPiecesFor(selectedItem.itemsPerCarton);
    if (totalPieces <= 0) {
      _showValidationMessage('اكتب عدد الكراتين أو القطع.');
      return;
    }

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
        itemName: selectedItem.name,
        quantity: totalPieces,
        unit: 'قطعة',
      ),
    );
  }

  void _showValidationMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
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
            InventoryItemSelectorField(
              selectedItem: _selectedItem,
              onSelected: (item) => setState(() {
                _selectedItem = item;
                _quantity = const CartonPieceQuantity(cartons: 0, pieces: 0);
              }),
            ),
            SizedBox(height: AppSizes.h16),
            if (_selectedItem case final item?) ...[
              CartonPieceQuantityFields(
                key: ValueKey(item.id),
                keyPrefix: 'outbound-quantity',
                itemsPerCarton: item.itemsPerCarton,
                onChanged: (value) => _quantity = value,
              ),
              SizedBox(height: AppSizes.h16),
            ],
            CustomTextField(
              label: AppStrings.transactionDate,
              controller: _dateController,
              prefixIcon: Icons.calendar_today,
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
                final selectedItem = _selectedItem;
                if (selectedItem == null) {
                  _showValidationMessage('اختر الصنف أولًا.');
                  return;
                }
                final totalPieces = _quantity.totalPiecesFor(
                  selectedItem.itemsPerCarton,
                );
                if (totalPieces <= 0) {
                  _showValidationMessage('اكتب عدد الكراتين أو القطع.');
                  return;
                }

                context.read<TransactionsCubit>().createOutboundTransaction(
                  itemName: selectedItem.name,
                  itemCode: selectedItem.code,
                  quantity: totalPieces,
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
