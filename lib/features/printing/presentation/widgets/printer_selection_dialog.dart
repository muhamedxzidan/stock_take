import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../cubit/printer_cubit.dart';
import '../../cubit/printer_state.dart';
import '../../data/models/printer_connection_profile.dart';
import '../../data/models/printer_discovery_snapshot.dart';
import '../../data/models/saved_printer.dart';

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
    if (!_cubit.state.connectionProfile.requiresUserGestureForDiscovery) {
      unawaited(_cubit.startDiscovery());
    }
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
    final isWebBluetooth =
        state.connectionProfile.mode ==
        PrinterConnectionMode.webBluetoothLowEnergy;
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
                    isWebBluetooth
                        ? 'تجربة الطابعة من Chrome'
                        : 'اختيار طابعة البلوتوث',
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
              isWebBluetooth
                  ? 'اضغط زر البحث ليعرض Chrome أجهزة BLE القريبة. '
                        'لو ظهرت XP-P802A واخترتها سيستمر الاعتماد عليها '
                        'طوال جلسة العمل. لو لم تظهر فالغالب أن وحدتها '
                        'Bluetooth Classic وسنستخدم خيار الربط المحلي.'
                  : 'شغّل الطابعة واقرنها من إعدادات Android أول مرة. '
                        'بعد اختيارها هنا سيحفظها التطبيق ويستخدمها تلقائيًا.',
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
                        _PrinterMessage(
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
                        child: _PrinterResults(
                          state: state,
                          printers: printers,
                          isWebBluetooth: isWebBluetooth,
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
                state.availability == PrinterDiscoveryAvailability.idle &&
                        isWebBluetooth
                    ? 'بدء البحث من Chrome'
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

class _PrinterResults extends StatelessWidget {
  final PrinterState state;
  final List<SavedPrinter> printers;
  final bool isWebBluetooth;
  final ValueChanged<SavedPrinter> onSelect;

  const _PrinterResults({
    required this.state,
    required this.printers,
    required this.isWebBluetooth,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isConnecting) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('جارٍ الاتصال بالطابعة واعتمادها...'),
          ],
        ),
      );
    }

    if (printers.isEmpty &&
        state.availability == PrinterDiscoveryAvailability.searching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (printers.isEmpty) {
      return Center(
        child: Text(
          _emptyMessage(state.availability, isWebBluetooth),
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium,
        ),
      );
    }

    return ListView.separated(
      itemCount: printers.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final printer = printers[index];
        final isSelected = printer == state.selectedPrinter;
        return ListTile(
          key: Key('printer-device-${printer.address}'),
          leading: Icon(
            isSelected ? Icons.print_rounded : Icons.bluetooth_rounded,
            color: isSelected ? AppColors.success : AppColors.primary,
          ),
          title: Text(printer.displayName),
          subtitle: Text(
            printer.address,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.right,
          ),
          trailing: isSelected
              ? const Icon(Icons.check_circle_rounded, color: AppColors.success)
              : const Icon(Icons.chevron_left_rounded),
          onTap: () => onSelect(printer),
        );
      },
    );
  }

  String _emptyMessage(
    PrinterDiscoveryAvailability availability,
    bool isWebBluetooth,
  ) {
    return switch (availability) {
      PrinterDiscoveryAvailability.idle =>
        isWebBluetooth
            ? 'ابدأ البحث من الزر بالأسفل، ثم اختر XP-P802A من قائمة Chrome.'
            : 'جارٍ تجهيز البحث عن الطابعة.',
      PrinterDiscoveryAvailability.bluetoothDisabled =>
        'البلوتوث مغلق. شغّله ثم اضغط إعادة البحث.',
      PrinterDiscoveryAvailability.permissionDenied =>
        'صلاحية أجهزة البلوتوث القريبة مطلوبة للبحث والاتصال.',
      PrinterDiscoveryAvailability.unsupported =>
        isWebBluetooth
            ? 'Web Bluetooth غير متاح. استخدم Chrome على Android ورابط HTTPS.'
            : 'اتصال الطابعة المباشر غير مدعوم على هذا الجهاز.',
      PrinterDiscoveryAvailability.failure =>
        'تعذر البحث. تحقق من تشغيل البلوتوث ثم أعد المحاولة.',
      _ =>
        isWebBluetooth
            ? 'لم تُختر طابعة BLE. أعد البحث واختر XP-P802A إن ظهرت. '
                  'عدم ظهورها يعني غالبًا أن إصدارها Bluetooth Classic.'
            : 'لم تظهر طابعات. اقترن بـ XP-P802A من إعدادات Android '
                  'ثم أعد البحث. رمز الاقتران المعتاد 0000.',
    };
  }
}

class _PrinterMessage extends StatelessWidget {
  final String message;
  final bool isError;

  const _PrinterMessage({required this.message, required this.isError});

  @override
  Widget build(BuildContext context) {
    final color = isError ? AppColors.error : AppColors.info;
    return Container(
      padding: EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: Text(
        message,
        style: AppTextStyles.bodySmall.copyWith(color: color),
      ),
    );
  }
}
