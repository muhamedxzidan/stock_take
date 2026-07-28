import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/shared_widgets/custom_app_bar.dart';
import '../../../stocktake/cubit/stocktake_cubit.dart';
import '../../../stocktake/cubit/stocktake_state.dart';
import '../../../stocktake/presentation/widgets/start_stocktake_card.dart';
import '../../../stocktake/presentation/widgets/stocktake_session_view.dart';

class StockAdjustmentScreen extends StatefulWidget {
  const StockAdjustmentScreen({super.key});

  @override
  State<StockAdjustmentScreen> createState() => _StockAdjustmentScreenState();
}

class _StockAdjustmentScreenState extends State<StockAdjustmentScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StocktakeCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.stocktake,
        leading: IconButton(
          key: const Key('stocktake-to-new-movement'),
          tooltip: AppStrings.backToNewMovement,
          onPressed: () => context.go(AppRoutes.newMovement),
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ),
      body: BlocConsumer<StocktakeCubit, StocktakeState>(
        listenWhen: (previous, current) =>
            current is StocktakeFailure || current is StocktakeCompleted,
        listener: (context, state) {
          if (state is StocktakeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is StocktakeCompleted) {
            final completion = state.completion;
            final movement = completion.movementVoucherNumber == null
                ? 'بدون فروق'
                : 'حركة ${completion.movementVoucherNumber}';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم اعتماد ${completion.stocktakeNumber} • $movement',
                ),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is StocktakeInitial || state is StocktakeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final ready = state as StocktakeReady;
          final session = ready.session;
          if (session == null) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.p20),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: StartStocktakeCard(
                    isStarting:
                        state is StocktakeActionInProgress &&
                        state.action == StocktakeAction.starting,
                    onStart: context.read<StocktakeCubit>().startStocktake,
                  ),
                ),
              ),
            );
          }

          final action = state is StocktakeActionInProgress
              ? state.action
              : null;
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              padding: EdgeInsets.all(AppSizes.p20),
              child: StocktakeSessionView(
                session: session,
                lines: ready.lines,
                savingItemId: action == StocktakeAction.savingCount
                    ? (state as StocktakeActionInProgress).itemId
                    : null,
                isCompleting: action == StocktakeAction.completing,
                onSaveCount: context.read<StocktakeCubit>().saveCount,
                onComplete: context.read<StocktakeCubit>().completeStocktake,
              ),
            ),
          );
        },
      ),
    );
  }
}
