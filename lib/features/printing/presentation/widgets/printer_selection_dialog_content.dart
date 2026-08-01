import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../cubit/printer_state.dart';
import '../../data/models/printer_discovery_snapshot.dart';
import '../../data/models/saved_printer.dart';

class PrinterSelectionResults extends StatelessWidget {
  final PrinterState state;
  final List<SavedPrinter> printers;
  final ValueChanged<SavedPrinter> onSelect;

  const PrinterSelectionResults({
    super.key,
    required this.state,
    required this.printers,
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
          _emptyMessage(state.availability),
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

  String _emptyMessage(PrinterDiscoveryAvailability availability) {
    return switch (availability) {
      PrinterDiscoveryAvailability.idle => 'جارٍ تجهيز البحث عن الطابعة.',
      PrinterDiscoveryAvailability.bluetoothDisabled =>
        'البلوتوث مغلق. شغّله ثم اضغط إعادة البحث.',
      PrinterDiscoveryAvailability.permissionDenied =>
        'صلاحية أجهزة البلوتوث القريبة مطلوبة للبحث والاتصال.',
      PrinterDiscoveryAvailability.unsupported =>
        'الطباعة بالبلوتوث متاحة من تطبيق Android فقط.',
      PrinterDiscoveryAvailability.failure =>
        'تعذر البحث. تحقق من تشغيل البلوتوث ثم أعد المحاولة.',
      _ =>
        'لم تظهر طابعات. اقترن بـ XP-P802A من إعدادات Android '
            'ثم أعد البحث. قد تظهر باسم print001-57bb.',
    };
  }
}

class PrinterSelectionMessage extends StatelessWidget {
  final String message;
  final bool isError;

  const PrinterSelectionMessage({
    super.key,
    required this.message,
    required this.isError,
  });

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
