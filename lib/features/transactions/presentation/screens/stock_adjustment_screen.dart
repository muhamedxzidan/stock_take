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

class StockAdjustmentScreen extends StatelessWidget {
  const StockAdjustmentScreen({super.key});

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
            current is StocktakeFailure ||
            current is StocktakeCompleted ||
            current is StocktakeCancelled,
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
          } else if (state is StocktakeCancelled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم إلغاء ${state.stocktakeNumber} دون تعديل المخزون.',
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

          if (state is StocktakeFailure && state.session == null) {
            return _StocktakeLoadFailure(
              message: state.message,
              onRetry: context.read<StocktakeCubit>().load,
            );
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
                isCancelling: action == StocktakeAction.cancelling,
                onSaveCount: context.read<StocktakeCubit>().saveCount,
                onComplete: context.read<StocktakeCubit>().completeStocktake,
                onCancel: () => _confirmCancellation(context),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _confirmCancellation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('إلغاء جلسة الجرد؟'),
        content: const Text(
          'سيتم حذف حالة الجرد المفتوح فقط دون تغيير أي رصيد أو حركة مخزون. '
          'يمكنك بعدها بدء جرد جديد برصيد نظام حديث.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('رجوع'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('تأكيد الإلغاء'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return false;
    }
    return context.read<StocktakeCubit>().cancelStocktake();
  }
}

class _StocktakeLoadFailure extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _StocktakeLoadFailure({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color: AppColors.error,
              size: 48,
            ),
            SizedBox(height: AppSizes.h12),
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: AppSizes.h12),
            FilledButton.icon(
              key: const Key('retry-stocktake-load'),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
