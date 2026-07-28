import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/shared_widgets/custom_button.dart';
import '../../../../core/shared_widgets/custom_text_field.dart';
import '../../data/models/stocktake_session.dart';

class StartStocktakeCard extends StatefulWidget {
  final bool isStarting;
  final Future<bool> Function(StartStocktakeDraft draft) onStart;

  const StartStocktakeCard({
    super.key,
    required this.isStarting,
    required this.onStart,
  });

  @override
  State<StartStocktakeCard> createState() => _StartStocktakeCardState();
}

class _StartStocktakeCardState extends State<StartStocktakeCard> {
  final _notesController = TextEditingController();
  late DateTime _periodFrom;
  late DateTime _periodTo;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _periodFrom = DateTime(now.year, now.month, now.day);
    _periodTo = _periodFrom;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate({required bool isFrom}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: isFrom ? _periodFrom : _periodTo,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      if (isFrom) {
        _periodFrom = selected;
        if (_periodTo.isBefore(selected)) {
          _periodTo = selected;
        }
      } else {
        _periodTo = selected;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.fact_check_outlined, size: 52, color: AppColors.warning),
            SizedBox(height: AppSizes.h12),
            Text(
              'ابدأ جلسة جرد جديدة',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading2,
            ),
            SizedBox(height: AppSizes.h8),
            Text(
              'سيتم تثبيت رصيد النظام لكل صنف عند بدء الجلسة، '
              'ثم يمكنك حفظ العدد الفعلي تدريجيًا.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: AppSizes.h20),
            Row(
              children: [
                Expanded(
                  child: _DateButton(
                    buttonKey: const Key('stocktake-period-from'),
                    label: 'من',
                    date: _periodFrom,
                    onPressed: () => _selectDate(isFrom: true),
                  ),
                ),
                SizedBox(width: AppSizes.p12),
                Expanded(
                  child: _DateButton(
                    buttonKey: const Key('stocktake-period-to'),
                    label: 'إلى',
                    date: _periodTo,
                    onPressed: () => _selectDate(isFrom: false),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h16),
            CustomTextField(
              fieldKey: const Key('stocktake-notes-field'),
              label: 'ملاحظات الجلسة',
              hint: 'اختياري',
              controller: _notesController,
              maxLines: 3,
              prefixIcon: Icons.notes_rounded,
            ),
            SizedBox(height: AppSizes.h20),
            CustomButton(
              key: const Key('start-stocktake'),
              text: 'بدء جلسة الجرد',
              icon: Icons.play_arrow_rounded,
              backgroundColor: AppColors.warning,
              isLoading: widget.isStarting,
              onPressed: () => widget.onStart(
                StartStocktakeDraft(
                  periodFrom: _periodFrom,
                  periodTo: _periodTo,
                  notes: _notesController.text.trim(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final Key buttonKey;
  final String label;
  final DateTime date;
  final VoidCallback onPressed;

  const _DateButton({
    required this.buttonKey,
    required this.label,
    required this.date,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      key: buttonKey,
      onPressed: onPressed,
      icon: const Icon(Icons.calendar_month_outlined),
      label: Text('$label: ${_formatDate(date)}'),
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
