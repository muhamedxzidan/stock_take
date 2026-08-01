import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/shared_widgets/custom_button.dart';
import '../../data/models/stocktake_line.dart';
import '../../data/models/stocktake_session.dart';
import 'stocktake_line_card.dart';
import 'stocktake_session_header.dart';

class StocktakeSessionView extends StatelessWidget {
  final StocktakeSession session;
  final List<StocktakeLine> lines;
  final String? savingItemId;
  final bool isCompleting;
  final bool isCancelling;
  final Future<bool> Function({
    required String itemId,
    required int actualQuantityPieces,
  })
  onSaveCount;
  final Future<SavedStocktakeCompletion?> Function() onComplete;
  final Future<bool> Function() onCancel;

  const StocktakeSessionView({
    super.key,
    required this.session,
    required this.lines,
    required this.savingItemId,
    required this.isCompleting,
    required this.isCancelling,
    required this.onSaveCount,
    required this.onComplete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final countedItems = lines.where((line) => line.counted).length;
    final netDifference = lines
        .where((line) => line.counted)
        .fold<int>(0, (total, line) => total + line.differencePieces);
    final isBusy = isCompleting || isCancelling || savingItemId != null;
    final canComplete =
        lines.isNotEmpty && countedItems == lines.length && !isBusy;

    return Column(
      children: [
        StocktakeSessionHeader(
          session: session,
          countedItems: countedItems,
          totalItems: lines.length,
          netDifference: netDifference,
        ),
        SizedBox(height: AppSizes.h12),
        Expanded(
          child: lines.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  key: const Key('stocktake-lines-list'),
                  padding: EdgeInsets.only(bottom: AppSizes.p20),
                  itemCount: lines.length,
                  separatorBuilder: (_, _) => SizedBox(height: AppSizes.h12),
                  itemBuilder: (context, index) {
                    final line = lines[index];
                    return StocktakeLineCard(
                      key: ValueKey(
                        '${line.itemId}-${line.actualQuantityPieces}-${line.counted}',
                      ),
                      line: line,
                      isSaving: savingItemId == line.itemId,
                      onSave: (actualQuantityPieces) => onSaveCount(
                        itemId: line.itemId,
                        actualQuantityPieces: actualQuantityPieces,
                      ),
                    );
                  },
                ),
        ),
        SizedBox(height: AppSizes.h12),
        CustomButton(
          key: const Key('complete-stocktake'),
          text: countedItems == lines.length
              ? 'اعتماد الفروق وإنهاء الجرد'
              : 'تم عدّ $countedItems من ${lines.length}',
          icon: Icons.verified_outlined,
          backgroundColor: canComplete
              ? AppColors.success
              : AppColors.textLight,
          isLoading: isCompleting,
          onPressed: canComplete ? onComplete : () {},
        ),
        SizedBox(height: AppSizes.h8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            key: const Key('cancel-stocktake'),
            onPressed: isBusy ? null : onCancel,
            icon: isCancelling
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cancel_outlined),
            label: const Text('إلغاء الجرد دون تعديل المخزون'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
          ),
        ),
      ],
    );
  }
}
