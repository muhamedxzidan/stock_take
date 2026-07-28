import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/shared_widgets/custom_app_bar.dart';
import '../../../../core/shared_widgets/custom_text_field.dart';
import '../../cubit/movement_history_cubit.dart';
import '../../cubit/movement_history_state.dart';
import '../../data/models/movement_report_summary.dart';
import '../widgets/transaction_filter_bar.dart';
import '../widgets/transaction_list_item.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MovementHistoryCubit>().loadMovements();
  }

  Future<void> _selectDateRange(MovementHistorySuccess state) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: state.dateFrom != null && state.dateTo != null
          ? DateTimeRange(start: state.dateFrom!, end: state.dateTo!)
          : null,
      helpText: 'اختر فترة التقرير',
      cancelText: 'إلغاء',
      confirmText: 'تطبيق',
      saveText: 'تطبيق',
    );
    if (range == null || !mounted) {
      return;
    }
    context.read<MovementHistoryCubit>().setDateRange(
      from: range.start,
      to: range.end,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.transactionHistoryTitle),
      body: BlocBuilder<MovementHistoryCubit, MovementHistoryState>(
        builder: (context, state) {
          if (state is MovementHistoryInitial ||
              state is MovementHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MovementHistoryFailure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, style: AppTextStyles.bodyLarge),
                  SizedBox(height: AppSizes.h12),
                  FilledButton.icon(
                    onPressed: () =>
                        context.read<MovementHistoryCubit>().loadMovements(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }
          if (state is! MovementHistorySuccess) {
            return const SizedBox.shrink();
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(AppSizes.p16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          fieldKey: const Key('movement-history-search'),
                          label: 'البحث في سجل الحركات',
                          hint:
                              'ابحث برقم الإذن، اسم/كود الصنف، المورد أو المستلم...',
                          prefixIcon: Icons.search,
                          onChanged: context
                              .read<MovementHistoryCubit>()
                              .onSearchChanged,
                        ),
                        SizedBox(height: AppSizes.h12),
                        const TransactionFilterBar(),
                        SizedBox(height: AppSizes.h12),
                        _DateFilterBar(
                          state: state,
                          onSelectRange: () => _selectDateRange(state),
                        ),
                        SizedBox(height: AppSizes.h12),
                        _MovementReportSummaryBar(summary: state.summary),
                      ],
                    ),
                  ),
                  Expanded(
                    child: state.movements.isEmpty
                        ? Center(
                            child: Text(
                              'لا توجد حركات مطابقة للفلاتر الحالية.',
                              style: AppTextStyles.bodyMedium,
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.fromLTRB(
                              AppSizes.p16,
                              0,
                              AppSizes.p16,
                              AppSizes.p16,
                            ),
                            itemCount: state.movements.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: AppSizes.h12),
                            itemBuilder: (context, index) {
                              return TransactionListItem(
                                movement: state.movements[index],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DateFilterBar extends StatelessWidget {
  final MovementHistorySuccess state;
  final VoidCallback onSelectRange;

  const _DateFilterBar({required this.state, required this.onSelectRange});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MovementHistoryCubit>();
    return Wrap(
      spacing: AppSizes.p8,
      runSpacing: AppSizes.h8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('كل التواريخ'),
          selected: state.dateFilterMode == MovementDateFilterMode.all,
          onSelected: (_) => cubit.showAllDates(),
        ),
        ChoiceChip(
          label: const Text('تقرير اليوم'),
          selected: state.dateFilterMode == MovementDateFilterMode.today,
          onSelected: (_) => cubit.showToday(),
        ),
        ChoiceChip(
          key: const Key('movement-history-date-range'),
          avatar: const Icon(Icons.date_range_outlined, size: 18),
          label: Text(
            state.dateFilterMode == MovementDateFilterMode.range
                ? _rangeLabel(state.dateFrom!, state.dateTo!)
                : 'من / إلى',
          ),
          selected: state.dateFilterMode == MovementDateFilterMode.range,
          onSelected: (_) => onSelectRange(),
        ),
      ],
    );
  }

  String _rangeLabel(DateTime from, DateTime to) {
    return '${_shortDate(from)} ← ${_shortDate(to)}';
  }

  String _shortDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}

class _MovementReportSummaryBar extends StatelessWidget {
  final MovementReportSummary summary;

  const _MovementReportSummaryBar({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.p8,
      runSpacing: AppSizes.h8,
      children: [
        _SummaryChip(
          label: 'الحركات',
          value: summary.movementCount,
          suffix: ' حركة',
          color: AppColors.primary,
        ),
        _SummaryChip(
          label: 'الوارد',
          value: summary.inboundPieces,
          color: AppColors.success,
        ),
        _SummaryChip(
          label: 'المنصرف',
          value: summary.outboundPieces,
          color: AppColors.error,
        ),
        _SummaryChip(
          label: 'مرتجع العميل',
          value: summary.customerReturnPieces,
          color: AppColors.success,
        ),
        _SummaryChip(
          label: 'للمورد',
          value: summary.supplierReturnPieces,
          color: AppColors.error,
        ),
        _SummaryChip(
          label: 'الاستبدال',
          value: summary.supplierReplacementCount,
          suffix: ' حركة',
          color: AppColors.secondary,
        ),
        _SummaryChip(
          label: 'صافي الجرد',
          value: summary.stocktakeAdjustmentNetPieces,
          color: AppColors.warning,
        ),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final int value;
  final String suffix;
  final Color color;

  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
    this.suffix = ' قطعة',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p12,
        vertical: AppSizes.h8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.r24),
      ),
      child: Text(
        '$label: $value$suffix',
        style: AppTextStyles.bodyMedium.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
