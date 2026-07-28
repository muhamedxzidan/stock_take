import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/shared_widgets/custom_text_field.dart';
import 'movement_ui_types.dart';

class MovementDetailsSheet extends StatefulWidget {
  final MovementKind movementKind;

  const MovementDetailsSheet({super.key, required this.movementKind});

  @override
  State<MovementDetailsSheet> createState() => _MovementDetailsSheetState();
}

class _MovementDetailsSheetState extends State<MovementDetailsSheet> {
  final _partyController = TextEditingController();
  final _deliveredByController = TextEditingController();
  final _receivedByController = TextEditingController();
  final _driverController = TextEditingController();
  final _notesController = TextEditingController();
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateController = TextEditingController(
      text:
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
    );
  }

  @override
  void dispose() {
    _partyController.dispose();
    _deliveredByController.dispose();
    _receivedByController.dispose();
    _driverController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_partyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.movementKind == MovementKind.inbound
                ? 'اكتب اسم المورد للمتابعة.'
                : 'اكتب اسم الجهة المستلمة للمتابعة.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      MovementVoucherDetails(
        partyName: _partyController.text.trim(),
        deliveredBy: _deliveredByController.text.trim(),
        receivedBy: _receivedByController.text.trim(),
        driverName: _driverController.text.trim(),
        date: _dateController.text.trim(),
        notes: _notesController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSizes.p20,
          AppSizes.p12,
          AppSizes.p20,
          MediaQuery.viewInsetsOf(context).bottom + AppSizes.p20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(AppSizes.r24),
                ),
              ),
            ),
            SizedBox(height: AppSizes.h16),
            Text('بيانات الإذن', style: AppTextStyles.heading1),
            SizedBox(height: AppSizes.h4),
            Text(
              'اكتب البيانات العامة مرة واحدة لكل الأصناف.',
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: AppSizes.h20),
            CustomTextField(
              label: widget.movementKind == MovementKind.inbound
                  ? AppStrings.supplierName
                  : AppStrings.recipientEntity,
              hint: widget.movementKind == MovementKind.inbound
                  ? 'اسم الشركة الموردة'
                  : 'الفرع أو القسم المستلم',
              controller: _partyController,
              prefixIcon: widget.movementKind == MovementKind.inbound
                  ? Icons.business_outlined
                  : Icons.store_outlined,
            ),
            SizedBox(height: AppSizes.h16),
            LayoutBuilder(
              builder: (context, constraints) {
                final fields = [
                  CustomTextField(
                    label: AppStrings.deliveredBy,
                    hint: 'اسم من سلّم',
                    controller: _deliveredByController,
                    prefixIcon: Icons.person_outline,
                  ),
                  CustomTextField(
                    label: AppStrings.receivedBy,
                    hint: 'اسم من استلم',
                    controller: _receivedByController,
                    prefixIcon: Icons.person_rounded,
                  ),
                ];

                if (constraints.maxWidth < 560) {
                  return Column(
                    children: [
                      fields.first,
                      SizedBox(height: AppSizes.h16),
                      fields.last,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: fields.first),
                    SizedBox(width: AppSizes.p12),
                    Expanded(child: fields.last),
                  ],
                );
              },
            ),
            SizedBox(height: AppSizes.h16),
            LayoutBuilder(
              builder: (context, constraints) {
                final driverField = CustomTextField(
                  label: '${AppStrings.driverName} (اختياري)',
                  hint: 'اسم سائق السيارة',
                  controller: _driverController,
                  prefixIcon: Icons.local_shipping_outlined,
                );
                final dateField = CustomTextField(
                  label: AppStrings.transactionDate,
                  controller: _dateController,
                  prefixIcon: Icons.calendar_today_outlined,
                );

                if (constraints.maxWidth < 560) {
                  return Column(
                    children: [
                      driverField,
                      SizedBox(height: AppSizes.h16),
                      dateField,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: driverField),
                    SizedBox(width: AppSizes.p12),
                    Expanded(child: dateField),
                  ],
                );
              },
            ),
            SizedBox(height: AppSizes.h16),
            CustomTextField(
              label: '${AppStrings.notes} (اختياري)',
              hint: 'أي تفاصيل إضافية عن الإذن',
              controller: _notesController,
              prefixIcon: Icons.notes_rounded,
              maxLines: 2,
            ),
            SizedBox(height: AppSizes.h20),
            FilledButton.icon(
              key: const Key('movement-details-preview'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: Size(double.infinity, AppSizes.buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                ),
              ),
              onPressed: _continue,
              icon: const Icon(Icons.visibility_outlined),
              label: Text('معاينة الإذن', style: AppTextStyles.buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
