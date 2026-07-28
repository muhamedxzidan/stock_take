import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../cubit/return_resolution_cubit.dart';
import '../../cubit/return_resolution_state.dart';
import '../../data/models/return_resolution.dart';
import '../../data/models/warehouse_return_draft.dart';
import '../../data/models/warehouse_return_record.dart';

class ReturnWorkflowCard extends StatelessWidget {
  const ReturnWorkflowCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReturnResolutionCubit, ReturnResolutionState>(
      listenWhen: (previous, current) =>
          current is ReturnResolutionSaved ||
          current is ReturnResolutionFailure,
      listener: (context, state) {
        if (state is ReturnResolutionSaved) {
          final actionLabel =
              state.resolution.kind == ReturnResolutionKind.replaced
              ? 'تم استبداله'
              : 'رُجع للمورد';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تمت تسوية ${state.resolution.returnNumber}: $actionLabel.',
              ),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state is ReturnResolutionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.r16),
            side: const BorderSide(color: AppColors.border),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSizes.p20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSizes.p8),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSizes.r12),
                      ),
                      child: const Icon(
                        Icons.pending_actions_rounded,
                        color: AppColors.secondary,
                      ),
                    ),
                    SizedBox(width: AppSizes.p12),
                    Expanded(
                      child: Text(
                        'مرتجعات بانتظار تسوية المورد',
                        style: AppTextStyles.heading2,
                      ),
                    ),
                    _CountBadge(count: state.pendingReturns.length),
                  ],
                ),
                SizedBox(height: AppSizes.h16),
                if (state is ReturnResolutionLoading ||
                    state is ReturnResolutionInitial)
                  const Center(child: CircularProgressIndicator())
                else if (state.pendingReturns.isEmpty)
                  const _EmptyPendingReturns()
                else
                  ...state.pendingReturns.map(
                    (warehouseReturn) => Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.h12),
                      child: _PendingReturnTile(
                        warehouseReturn: warehouseReturn,
                        isResolving:
                            state is ReturnResolutionSaving &&
                            state.returnId == warehouseReturn.id,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PendingReturnTile extends StatelessWidget {
  final WarehouseReturnRecord warehouseReturn;
  final bool isResolving;

  const _PendingReturnTile({
    required this.warehouseReturn,
    required this.isResolving,
  });

  Future<void> _resolve(BuildContext context, ReturnResolutionKind kind) async {
    final supplierName = await showDialog<String>(
      context: context,
      builder: (context) => _ReturnResolutionDialog(
        returnNumber: warehouseReturn.returnNumber,
        kind: kind,
      ),
    );
    if (supplierName == null || !context.mounted) {
      return;
    }

    await context.read<ReturnResolutionCubit>().resolveReturn(
      ReturnResolutionDraft(
        returnId: warehouseReturn.id,
        supplierName: supplierName,
        kind: kind,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('pending-return-${warehouseReturn.id}'),
      padding: EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  warehouseReturn.returnNumber,
                  style: AppTextStyles.heading3,
                ),
              ),
              Text(
                '${warehouseReturn.quantityPieces} قطعة',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h4),
          Text(
            '${warehouseReturn.itemName} • ${warehouseReturn.itemCode}',
            style: AppTextStyles.bodyMedium,
          ),
          SizedBox(height: AppSizes.h4),
          Text(
            '${warehouseReturn.sourceName} • ${_conditionLabel(warehouseReturn.condition)}',
            style: AppTextStyles.bodySmall,
          ),
          SizedBox(height: AppSizes.h12),
          if (isResolving)
            const Center(child: CircularProgressIndicator())
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: Key('replace-return-${warehouseReturn.id}'),
                    onPressed: () =>
                        _resolve(context, ReturnResolutionKind.replaced),
                    icon: const Icon(Icons.swap_horiz_rounded),
                    label: const Text('تم استبداله'),
                  ),
                ),
                SizedBox(width: AppSizes.p8),
                Expanded(
                  child: FilledButton.icon(
                    key: Key('return-to-supplier-${warehouseReturn.id}'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.error,
                    ),
                    onPressed: () => _resolve(
                      context,
                      ReturnResolutionKind.returnedToSupplier,
                    ),
                    icon: const Icon(Icons.undo_rounded),
                    label: const Text('رُجع للمورد'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _conditionLabel(ReturnItemCondition condition) {
    return switch (condition) {
      ReturnItemCondition.readyForStock => 'صالح للمخزون',
      ReturnItemCondition.damaged => 'تالف',
      ReturnItemCondition.needsInspection => 'يحتاج فحص',
    };
  }
}

class _ReturnResolutionDialog extends StatefulWidget {
  final String returnNumber;
  final ReturnResolutionKind kind;

  const _ReturnResolutionDialog({
    required this.returnNumber,
    required this.kind,
  });

  @override
  State<_ReturnResolutionDialog> createState() =>
      _ReturnResolutionDialogState();
}

class _ReturnResolutionDialogState extends State<_ReturnResolutionDialog> {
  final _supplierController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _supplierController.dispose();
    super.dispose();
  }

  void _confirm() {
    final supplierName = _supplierController.text.trim();
    if (supplierName.isEmpty) {
      setState(() => _errorText = 'اكتب اسم المورد.');
      return;
    }
    Navigator.pop(context, supplierName);
  }

  @override
  Widget build(BuildContext context) {
    final returnsToSupplier =
        widget.kind == ReturnResolutionKind.returnedToSupplier;
    return AlertDialog(
      title: Text(returnsToSupplier ? 'إرجاع للمورد' : 'تأكيد الاستبدال'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            returnsToSupplier
                ? 'سيتم خصم كمية ${widget.returnNumber} من رصيد المخزن.'
                : 'سيتم توثيق الاستبدال بدون تغيير صافي الرصيد.',
            style: AppTextStyles.bodyMedium,
          ),
          SizedBox(height: AppSizes.h16),
          TextField(
            key: const Key('return-resolution-supplier-field'),
            controller: _supplierController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'اسم المورد',
              errorText: _errorText,
              prefixIcon: const Icon(Icons.business_outlined),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          key: const Key('confirm-return-resolution'),
          style: FilledButton.styleFrom(
            backgroundColor: returnsToSupplier
                ? AppColors.error
                : AppColors.secondary,
          ),
          onPressed: _confirm,
          child: const Text('تأكيد'),
        ),
      ],
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;

  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p8,
        vertical: AppSizes.h4,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.r24),
      ),
      child: Text(
        '$count',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.secondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyPendingReturns extends StatelessWidget {
  const _EmptyPendingReturns();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.successBackground,
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: Text(
        'لا توجد مرتجعات معلقة حاليًا.',
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success),
      ),
    );
  }
}
