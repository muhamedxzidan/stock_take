import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/carton_piece_quantity.dart';
import '../../../../core/shared_widgets/carton_piece_quantity_fields.dart';
import '../../../../core/shared_widgets/custom_button.dart';
import '../../data/models/stocktake_line.dart';
import '../../data/models/stocktake_session.dart';

class StocktakeSessionView extends StatelessWidget {
  final StocktakeSession session;
  final List<StocktakeLine> lines;
  final String? savingItemId;
  final bool isCompleting;
  final Future<bool> Function({
    required String itemId,
    required int actualQuantityPieces,
  })
  onSaveCount;
  final Future<SavedStocktakeCompletion?> Function() onComplete;

  const StocktakeSessionView({
    super.key,
    required this.session,
    required this.lines,
    required this.savingItemId,
    required this.isCompleting,
    required this.onSaveCount,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final countedItems = lines.where((line) => line.counted).length;
    final netDifference = lines
        .where((line) => line.counted)
        .fold<int>(0, (total, line) => total + line.differencePieces);
    final canComplete =
        lines.isNotEmpty && countedItems == lines.length && !isCompleting;

    return Column(
      children: [
        _SessionHeader(
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
                    return _StocktakeLineCard(
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
      ],
    );
  }
}

class _SessionHeader extends StatelessWidget {
  final StocktakeSession session;
  final int countedItems;
  final int totalItems;
  final int netDifference;

  const _SessionHeader({
    required this.session,
    required this.countedItems,
    required this.totalItems,
    required this.netDifference,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.infoBackground,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: AppColors.info),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(session.stocktakeNumber, style: AppTextStyles.heading2),
          SizedBox(height: AppSizes.h4),
          Text(
            'الفترة: ${_formatDate(session.periodFrom)} — '
            '${_formatDate(session.periodTo)}',
            style: AppTextStyles.bodyMedium,
          ),
          SizedBox(height: AppSizes.h8),
          Wrap(
            spacing: AppSizes.p16,
            runSpacing: AppSizes.h8,
            children: [
              Text(
                'التقدم: $countedItems / $totalItems',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'صافي الفرق الحالي: ${netDifference > 0 ? '+' : ''}'
                '$netDifference قطعة',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: netDifference < 0
                      ? AppColors.error
                      : AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StocktakeLineCard extends StatefulWidget {
  final StocktakeLine line;
  final bool isSaving;
  final Future<bool> Function(int actualQuantityPieces) onSave;

  const _StocktakeLineCard({
    super.key,
    required this.line,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<_StocktakeLineCard> createState() => _StocktakeLineCardState();
}

class _StocktakeLineCardState extends State<_StocktakeLineCard> {
  late CartonPieceQuantity _actualQuantity;

  @override
  void initState() {
    super.initState();
    final actual = widget.line.counted ? widget.line.actualQuantityPieces : 0;
    _actualQuantity = CartonPieceQuantity(
      cartons: actual ~/ widget.line.itemsPerCarton,
      pieces: actual % widget.line.itemsPerCarton,
    );
  }

  @override
  Widget build(BuildContext context) {
    final actualPieces = _actualQuantity.totalPiecesFor(
      widget.line.itemsPerCarton,
    );
    final difference = actualPieces - widget.line.systemQuantityPieces;

    return Card(
      key: Key('stocktake-line-${widget.line.itemId}'),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.line.itemNameSnapshot,
                        style: AppTextStyles.heading3,
                      ),
                      Text(
                        widget.line.itemCodeSnapshot,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.line.counted)
                  const Chip(
                    avatar: Icon(Icons.check_circle, size: 18),
                    label: Text('تم الحفظ'),
                  ),
              ],
            ),
            SizedBox(height: AppSizes.h12),
            Text(
              'رصيد النظام المثبّت: '
              '${widget.line.systemQuantityPieces} قطعة',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppSizes.h12),
            CartonPieceQuantityFields(
              keyPrefix: 'stocktake-${widget.line.itemId}',
              itemsPerCarton: widget.line.itemsPerCarton,
              initialValue: _actualQuantity,
              onChanged: (value) => setState(() => _actualQuantity = value),
            ),
            SizedBox(height: AppSizes.h12),
            Text(
              'الفرق: ${difference > 0 ? '+' : ''}$difference قطعة',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading3.copyWith(
                color: difference < 0
                    ? AppColors.error
                    : difference > 0
                    ? AppColors.success
                    : AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSizes.h12),
            CustomButton(
              key: Key('save-stocktake-line-${widget.line.itemId}'),
              text: widget.line.counted
                  ? 'تحديث العدد الفعلي'
                  : 'حفظ العدد الفعلي',
              icon: Icons.save_outlined,
              isLoading: widget.isSaving,
              onPressed: () async {
                final saved = await widget.onSave(actualPieces);
                if (saved && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم حفظ ${widget.line.itemCodeSnapshot}: '
                        '$actualPieces قطعة.',
                      ),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
