import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../cubit/printer_cubit.dart';
import '../../cubit/printer_state.dart';
import 'printer_selection_dialog.dart';

class PrinterSetupButton extends StatelessWidget {
  const PrinterSetupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrinterCubit, PrinterState>(
      buildWhen: (previous, current) =>
          previous.selectedPrinter != current.selectedPrinter ||
          previous.isConnecting != current.isConnecting,
      builder: (context, state) {
        return IconButton(
          key: const Key('printer-setup-button'),
          tooltip: state.selectedPrinter == null
              ? 'اختيار طابعة البلوتوث'
              : 'الطابعة المعتمدة: ${state.selectedPrinter!.displayName}',
          onPressed: state.isConnecting
              ? null
              : () => PrinterSelectionDialog.show(context),
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.print_rounded),
              PositionedDirectional(
                end: -3,
                bottom: -3,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: state.selectedPrinter == null
                        ? AppColors.warning
                        : AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
