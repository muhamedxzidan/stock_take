import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/carton_piece_quantity.dart';
import '../../../../core/models/inventory_item.dart';
import '../../../../core/shared_widgets/carton_piece_quantity_fields.dart';
import 'movement_ui_types.dart';

class ItemQuantitySheet extends StatefulWidget {
  final InventoryItem item;
  final MovementKind movementKind;
  final QuantitySelection initialSelection;

  const ItemQuantitySheet({
    super.key,
    required this.item,
    required this.movementKind,
    this.initialSelection = const QuantitySelection(cartons: 0, pieces: 0),
  });

  @override
  State<ItemQuantitySheet> createState() => _ItemQuantitySheetState();
}

class _ItemQuantitySheetState extends State<ItemQuantitySheet> {
  late int _cartons;
  late int _pieces;

  @override
  void initState() {
    super.initState();
    _cartons = widget.initialSelection.cartons;
    _pieces = widget.initialSelection.pieces;
  }

  int get _totalPieces => (_cartons * widget.item.itemsPerCarton) + _pieces;

  bool get _hasQuantity => _totalPieces > 0;

  bool get _exceedsAvailableStock =>
      widget.movementKind == MovementKind.outbound &&
      _totalPieces > widget.item.currentStockBalance;

  @override
  Widget build(BuildContext context) {
    final actionColor = widget.movementKind == MovementKind.inbound
        ? AppColors.success
        : AppColors.error;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSizes.p20,
          AppSizes.p12,
          AppSizes.p20,
          MediaQuery.viewInsetsOf(context).bottom + AppSizes.p20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(AppSizes.r24),
                ),
              ),
            ),
            SizedBox(height: AppSizes.h16),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.p12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: AppSizes.p12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.item.name, style: AppTextStyles.heading2),
                      SizedBox(height: AppSizes.h4),
                      Text(
                        '${widget.item.itemsPerCarton} قطعة/كرتونة • الرصيد ${widget.item.formattedCartonStock}',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'إغلاق',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h24),
            CartonPieceQuantityFields(
              keyPrefix: 'item-quantity',
              itemsPerCarton: widget.item.itemsPerCarton,
              initialValue: CartonPieceQuantity(
                cartons: _cartons,
                pieces: _pieces,
              ),
              onChanged: (value) {
                setState(() {
                  _cartons = value.cartons;
                  _pieces = value.pieces;
                });
              },
            ),
            SizedBox(height: AppSizes.h20),
            Container(
              padding: EdgeInsets.all(AppSizes.p16),
              decoration: BoxDecoration(
                color: _exceedsAvailableStock
                    ? AppColors.errorBackground
                    : AppColors.infoBackground,
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
              child: Row(
                children: [
                  Icon(
                    _exceedsAvailableStock
                        ? Icons.error_outline_rounded
                        : Icons.calculate_outlined,
                    color: _exceedsAvailableStock
                        ? AppColors.error
                        : AppColors.info,
                  ),
                  SizedBox(width: AppSizes.p12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الكمية: '
                          '${CartonPieceQuantity(cartons: _cartons, pieces: _pieces).cartonFirstLabel}',
                          style: AppTextStyles.heading2.copyWith(
                            color: _exceedsAvailableStock
                                ? AppColors.error
                                : AppColors.info,
                          ),
                        ),
                        Text(
                          'الإجمالي المكافئ: $_totalPieces قطعة',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: _exceedsAvailableStock
                                ? AppColors.error
                                : AppColors.info,
                          ),
                        ),
                        if (_exceedsAvailableStock)
                          Text(
                            'الكمية أكبر من الرصيد المعروض.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.h20),
            FilledButton.icon(
              key: const Key('item-quantity-add'),
              style: FilledButton.styleFrom(
                backgroundColor: actionColor,
                minimumSize: Size(double.infinity, AppSizes.buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                ),
              ),
              onPressed: !_hasQuantity || _exceedsAvailableStock
                  ? null
                  : () {
                      Navigator.pop(
                        context,
                        QuantitySelection(cartons: _cartons, pieces: _pieces),
                      );
                    },
              icon: const Icon(Icons.add_task_rounded),
              label: Text('إضافة للإذن', style: AppTextStyles.buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
