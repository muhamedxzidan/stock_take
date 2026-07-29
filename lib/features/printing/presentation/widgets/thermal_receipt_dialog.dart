import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/thermal_receipt_data.dart';
import '../../cubit/printer_cubit.dart';
import '../../cubit/printer_state.dart';
import 'printer_selection_dialog.dart';
import 'thermal_receipt_content.dart';

class ThermalReceiptDialog extends StatefulWidget {
  final ThermalReceiptData receipt;

  const ThermalReceiptDialog({super.key, required this.receipt});

  static Future<bool?> show(
    BuildContext context, {
    required ThermalReceiptData receipt,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<PrinterCubit>(),
        child: ThermalReceiptDialog(receipt: receipt),
      ),
    );
  }

  @override
  State<ThermalReceiptDialog> createState() => _ThermalReceiptDialogState();
}

class _ThermalReceiptDialogState extends State<ThermalReceiptDialog> {
  ThermalReceiptRasterizer? _rasterizer;

  Future<void> _print() async {
    final rasterizer = _rasterizer;
    if (rasterizer == null) {
      return;
    }

    final cubit = context.read<PrinterCubit>();
    final printed = await cubit.printReceipt(rasterizer);
    if (!mounted) {
      return;
    }

    final message =
        cubit.state.message ??
        (printed ? 'تم إرسال الإيصال للطابعة.' : 'تعذر إرسال الإيصال.');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: printed ? AppColors.success : AppColors.error,
      ),
    );
    if (printed) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(AppSizes.p16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 780),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.receipt_long_rounded,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: AppSizes.p8),
                  Expanded(
                    child: Text(
                      'طباعة ${widget.receipt.voucherNumber}',
                      style: AppTextStyles.heading2,
                    ),
                  ),
                  IconButton(
                    tooltip: 'إغلاق',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              Text(
                'الإيصال مصمم داخل عرض الطباعة الفعلي 72mm '
                '(576 نقطة) لطابعة XP-P802A.',
                style: AppTextStyles.bodySmall,
              ),
              SizedBox(height: AppSizes.h12),
              Expanded(
                child: Receipt(
                  backgroundColor: AppColors.surfaceVariant,
                  defaultTextStyle: const TextStyle(
                    fontFamily: 'sans-serif',
                    color: Colors.black,
                    fontSize: 24,
                    height: 1.15,
                  ),
                  builder: (_) =>
                      ThermalReceiptContent(receipt: widget.receipt),
                  onInitialized: (controller) {
                    controller.paperSize = PaperSize.mm80;
                    if (mounted) {
                      setState(() {
                        _rasterizer = _ReceiptControllerRasterizer(controller);
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: AppSizes.h12),
              BlocBuilder<PrinterCubit, PrinterState>(
                builder: (context, state) {
                  final selectedPrinter = state.selectedPrinter;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (state.isPrinting) ...[
                        LinearProgressIndicator(value: state.printingProgress),
                        SizedBox(height: AppSizes.h8),
                      ],
                      if (selectedPrinter == null)
                        FilledButton.icon(
                          key: const Key('receipt-select-printer'),
                          onPressed: state.isPrinting
                              ? null
                              : () => PrinterSelectionDialog.show(context),
                          icon: const Icon(Icons.bluetooth_searching_rounded),
                          label: const Text('اختيار طابعة والاتصال بها'),
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                key: const Key('receipt-print-button'),
                                onPressed:
                                    state.isPrinting || _rasterizer == null
                                    ? null
                                    : _print,
                                icon: state.isPrinting
                                    ? const SizedBox.square(
                                        dimension: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.surface,
                                        ),
                                      )
                                    : const Icon(Icons.print_rounded),
                                label: Text(
                                  state.isPrinting
                                      ? 'جارٍ الطباعة...'
                                      : 'طباعة على '
                                            '${selectedPrinter.displayName}',
                                ),
                              ),
                            ),
                            SizedBox(width: AppSizes.p8),
                            OutlinedButton(
                              onPressed: state.isPrinting
                                  ? null
                                  : () => PrinterSelectionDialog.show(context),
                              child: const Text('تغيير'),
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReceiptControllerRasterizer implements ThermalReceiptRasterizer {
  final ReceiptController _controller;

  _ReceiptControllerRasterizer(this._controller);

  @override
  Future<Uint8List> renderPng() => _controller.getImageBytes();
}
