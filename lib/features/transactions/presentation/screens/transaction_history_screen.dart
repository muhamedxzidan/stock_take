import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/shared_widgets/custom_app_bar.dart';
import '../../../../core/shared_widgets/custom_text_field.dart';
import '../../cubit/transactions_cubit.dart';
import '../../cubit/transactions_state.dart';
import '../widgets/transaction_filter_bar.dart';
import '../widgets/transaction_list_item.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.transactionHistoryTitle),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(AppSizes.p16),
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'البحث في سجل الحركات',
                      hint: 'ابحث برقم الإذن، اسم الصنف، المورد أو المستلم...',
                      prefixIcon: Icons.search,
                      onChanged: (val) => context.read<TransactionsCubit>().onSearchQueryChanged(val),
                    ),
                    SizedBox(height: AppSizes.h12),
                    const TransactionFilterBar(),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<TransactionsCubit, TransactionsState>(
                  buildWhen: (prev, curr) => curr is TransactionsSuccess || curr is TransactionsLoading,
                  builder: (context, state) {
                    if (state is TransactionsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is TransactionsSuccess) {
                      if (state.transactions.isEmpty) {
                        return Center(
                          child: Text(AppStrings.emptyList, style: AppTextStyles.bodyMedium),
                        );
                      }
                      return ListView.separated(
                        padding: EdgeInsets.all(AppSizes.p16),
                        itemCount: state.transactions.length,
                        separatorBuilder: (context, index) => SizedBox(height: AppSizes.h12),
                        itemBuilder: (context, index) {
                          return TransactionListItem(transaction: state.transactions[index]);
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
