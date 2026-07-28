import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../cubit/movement_history_cubit.dart';
import '../../cubit/movement_history_state.dart';
import '../../data/models/movement_record.dart';

class TransactionFilterBar extends StatelessWidget {
  const TransactionFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovementHistoryCubit, MovementHistoryState>(
      buildWhen: (previous, current) => current is MovementHistorySuccess,
      builder: (context, state) {
        final selected = state is MovementHistorySuccess
            ? state.selectedType
            : null;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFilterChip(
                context,
                label: AppStrings.filterAll,
                type: null,
                isSelected: selected == null,
              ),
              const SizedBox(width: 8.0),
              _buildFilterChip(
                context,
                label: AppStrings.filterInbound,
                type: MovementRecordType.inbound,
                isSelected: selected == MovementRecordType.inbound,
              ),
              const SizedBox(width: 8.0),
              _buildFilterChip(
                context,
                label: AppStrings.filterOutbound,
                type: MovementRecordType.outbound,
                isSelected: selected == MovementRecordType.outbound,
              ),
              const SizedBox(width: 8.0),
              _buildFilterChip(
                context,
                label: 'مرتجع عميل',
                type: MovementRecordType.customerReturn,
                isSelected: selected == MovementRecordType.customerReturn,
              ),
              const SizedBox(width: 8.0),
              _buildFilterChip(
                context,
                label: 'رجوع للمورد',
                type: MovementRecordType.supplierReturn,
                isSelected: selected == MovementRecordType.supplierReturn,
              ),
              const SizedBox(width: 8.0),
              _buildFilterChip(
                context,
                label: 'استبدال',
                type: MovementRecordType.supplierReplacement,
                isSelected: selected == MovementRecordType.supplierReplacement,
              ),
              const SizedBox(width: 8.0),
              _buildFilterChip(
                context,
                label: AppStrings.filterAdjustment,
                type: MovementRecordType.stocktakeAdjustment,
                isSelected: selected == MovementRecordType.stocktakeAdjustment,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required MovementRecordType? type,
    required bool isSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.surface : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (_) {
        context.read<MovementHistoryCubit>().filterByType(type);
      },
    );
  }
}
