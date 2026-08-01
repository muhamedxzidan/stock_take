import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../cubit/printer_cubit.dart';
import '../../cubit/printer_state.dart';
import '../../data/models/printer_discovery_snapshot.dart';
import '../../data/models/saved_printer.dart';
import 'printer_selection_dialog_content.dart';

class PrinterSelectionDialog extends StatefulWidget {
  const PrinterSelectionDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.background,
      builder: (_) => BlocProvider.value(
        value: context.read<PrinterCubit>(),
        child: const PrinterSelectionDialog(),
      ),
    );
  }

  @override
  State<PrinterSelectionDialog> createState() => _PrinterSelectionDialogState();
}

class _PrinterSelectionDialogState extends State<PrinterSelectionDialog> {
  late PrinterCubit _cubit;
  bool _started = false;
  String _query = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) {
      return;
    }
    _started = true;
    _cubit = context.read<PrinterCubit>();
    unawaited(_cubit.startDiscovery());
  }

  @override
  void dispose() {
    unawaited(_cubit.stopDiscovery());
    super.dispose();
  }

  Future<void> _select(SavedPrinter printer) async {
    final connected = await _cubit.selectAndConnect(printer);
    if (connected && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.sizeOf(context).height * 0.78;
    final state = context.watch<PrinterCubit>().state;
    return SizedBox(
      height: sheetHeight,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.print_rounded, color: AppColors.primary),
                SizedBox(width: AppSizes.p8),
                Expanded(
                  child: Text(
                    'اختيار طابعة البلوتوث',
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
            SizedBox(height: AppSizes.h8),
            Text(
              'شغّل طابعة XP-P802A واقرنها من إعدادات Android أول مرة. '
              'قد تظهر باسم print001-57bb. بعد اختيارها هنا سيحفظ التطبيق '
              'عنوانها ويستخدمها تلقائيًا.',
              style: AppTextStyles.bodySmall,
            ),
            SizedBox(height: AppSizes.h12),
            TextField(
              key: const Key('printer-search-field'),
              enabled: !state.isConnecting,
              decoration: const InputDecoration(
                labelText: 'البحث باسم الطابعة أو عنوانها',
                prefixIcon: Icon(Icons.search_rounded),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            SizedBox(height: AppSizes.h12),
            Expanded(
              child: BlocBuilder<PrinterCubit, PrinterState>(
                builder: (context, state) {
                  final printers = _filterPrinters(
                    state.discoveredPrinters,
                    _query,
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (state.message != null) ...[
                        PrinterSelectionMessage(
                          message: state.message!,
                          isError:
                              state.availability ==
                                  PrinterDiscoveryAvailability.failure ||
                              state.availability ==
                                  PrinterDiscoveryAvailability.permissionDenied,
                        ),
                        SizedBox(height: AppSizes.h8),
                      ],
                      Expanded(
                        child: PrinterSelectionResults(
                          state: state,
                          printers: printers,
                          onSelect: _select,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: AppSizes.h8),
            OutlinedButton.icon(
              key: const Key('printer-start-discovery-button'),
              onPressed:
                  state.isConnecting ||
                      state.availability ==
                          PrinterDiscoveryAvailability.searching
                  ? null
                  : () => _cubit.startDiscovery(),
              icon: Icon(
                state.availability == PrinterDiscoveryAvailability.idle
                    ? Icons.bluetooth_searching_rounded
                    : Icons.refresh_rounded,
              ),
              label: Text(
                state.availability == PrinterDiscoveryAvailability.idle
                    ? 'البحث عن الطابعة'
                    : 'إعادة البحث',
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<SavedPrinter> _filterPrinters(
    List<SavedPrinter> printers,
    String query,
  ) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return printers;
    }
    return printers
        .where(
          (printer) =>
              printer.displayName.toLowerCase().contains(normalizedQuery) ||
              printer.address.toLowerCase().contains(normalizedQuery),
        )
        .toList(growable: false);
  }
}
