import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/shared_widgets/custom_app_bar.dart';
import '../../../../core/shared_widgets/custom_text_field.dart';
import '../../cubit/dashboard_cubit.dart';
import '../../cubit/dashboard_state.dart';
import '../widgets/quick_action_bar.dart';
import '../widgets/stock_items_list.dart';
import '../widgets/stock_summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.dashboardTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: AppStrings.transactionHistoryTitle,
            onPressed: () => context.go(AppRoutes.transactionHistory),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.p20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<DashboardCubit, DashboardState>(
                  buildWhen: (prev, curr) => curr is DashboardSuccess,
                  builder: (context, state) {
                    if (state is DashboardSuccess) {
                      return StockSummaryCard(summary: state.summary);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                SizedBox(height: AppSizes.h20),
                const QuickActionBar(),
                SizedBox(height: AppSizes.h20),
                CustomTextField(
                  label: 'بحث سريع بالأصناف',
                  hint: AppStrings.searchHint,
                  prefixIcon: Icons.search,
                  onChanged: (val) => context.read<DashboardCubit>().onSearchChanged(val),
                ),
                SizedBox(height: AppSizes.h16),
                const StockItemsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
