import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../cubit/transactions_cubit.dart';
import '../../cubit/transactions_state.dart';
import '../../data/models/transaction_model.dart';

class TransactionFilterBar extends StatelessWidget {
  const TransactionFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsCubit, TransactionsState>(
      buildWhen: (prev, curr) => curr is TransactionsSuccess,
      builder: (context, state) {
        final selected = state is TransactionsSuccess ? state.selectedFilter : null;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFilterChip(context, label: AppStrings.filterAll, type: null, isSelected: selected == null),
              const SizedBox(width: 8.0),
              _buildFilterChip(context, label: AppStrings.filterInbound, type: TransactionType.inbound, isSelected: selected == TransactionType.inbound),
              const SizedBox(width: 8.0),
              _buildFilterChip(context, label: AppStrings.filterOutbound, type: TransactionType.outbound, isSelected: selected == TransactionType.outbound),
              const SizedBox(width: 8.0),
              _buildFilterChip(context, label: AppStrings.filterAdjustment, type: TransactionType.adjustment, isSelected: selected == TransactionType.adjustment),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required TransactionType? type,
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
        context.read<TransactionsCubit>().filterByType(type);
      },
    );
  }
}
