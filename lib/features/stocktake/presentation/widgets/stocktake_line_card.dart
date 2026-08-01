import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/carton_piece_quantity.dart';
import '../../../../core/shared_widgets/carton_piece_quantity_fields.dart';
import '../../../../core/shared_widgets/custom_button.dart';
import '../../data/models/stocktake_line.dart';

/// Owns the editable local quantity draft for one stocktake line.
class StocktakeLineCard extends StatefulWidget {
  final StocktakeLine line;
  final bool isSaving;
  final Future<bool> Function(int actualQuantityPieces) onSave;

  const StocktakeLineCard({
    super.key,
    required this.line,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<StocktakeLineCard> createState() => _StocktakeLineCardState();
}

class _StocktakeLineCardState extends State<StocktakeLineCard> {
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
              '${CartonPieceQuantity.fromTotalPieces(totalPieces: widget.line.systemQuantityPieces, itemsPerCarton: widget.line.itemsPerCarton).cartonFirstLabel}'
              ' • ${widget.line.systemQuantityPieces} قطعة إجمالي',
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
              'الفرق: ${_signedCartonFirstQuantity(difference, widget.line.itemsPerCarton)}',
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
                        '${_actualQuantity.cartonFirstLabel}'
                        ' • $actualPieces قطعة إجمالي.',
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

String _signedCartonFirstQuantity(int totalPieces, int itemsPerCarton) {
  final sign = totalPieces > 0
      ? '+'
      : totalPieces < 0
      ? '-'
      : '';
  final quantity = CartonPieceQuantity.fromTotalPieces(
    totalPieces: totalPieces.abs(),
    itemsPerCarton: itemsPerCarton,
  );
  return '$sign${quantity.cartonFirstLabel}';
}
