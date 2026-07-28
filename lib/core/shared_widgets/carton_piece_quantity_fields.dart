import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';
import '../extensions/inventory_number_parsing.dart';
import '../models/carton_piece_quantity.dart';
import 'custom_text_field.dart';

class CartonPieceQuantityFields extends StatefulWidget {
  final String keyPrefix;
  final int itemsPerCarton;
  final CartonPieceQuantity initialValue;
  final ValueChanged<CartonPieceQuantity> onChanged;

  const CartonPieceQuantityFields({
    super.key,
    required this.keyPrefix,
    required this.itemsPerCarton,
    required this.onChanged,
    this.initialValue = const CartonPieceQuantity(cartons: 0, pieces: 0),
  });

  @override
  State<CartonPieceQuantityFields> createState() =>
      _CartonPieceQuantityFieldsState();
}

class _CartonPieceQuantityFieldsState extends State<CartonPieceQuantityFields> {
  late final TextEditingController _cartonsController;
  late final TextEditingController _piecesController;
  late CartonPieceQuantity _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _cartonsController = TextEditingController(
      text: widget.initialValue.cartons == 0
          ? ''
          : '${widget.initialValue.cartons}',
    );
    _piecesController = TextEditingController(
      text: widget.initialValue.pieces == 0
          ? ''
          : '${widget.initialValue.pieces}',
    );
  }

  @override
  void dispose() {
    _cartonsController.dispose();
    _piecesController.dispose();
    super.dispose();
  }

  void _onQuantityChanged() {
    final cartons = _cartonsController.text.toInventoryInteger() ?? 0;
    final pieces = _piecesController.text.toInventoryInteger() ?? 0;
    final nextValue = CartonPieceQuantity(cartons: cartons, pieces: pieces);

    setState(() => _value = nextValue);
    widget.onChanged(nextValue);
  }

  @override
  Widget build(BuildContext context) {
    final totalPieces = _value.totalPiecesFor(widget.itemsPerCarton);
    final digitFormatter = FilteringTextInputFormatter.allow(
      RegExp(r'[0-9٠-٩۰-۹]'),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                fieldKey: Key('${widget.keyPrefix}-cartons-field'),
                label: 'عدد الكراتين',
                hint: '0',
                controller: _cartonsController,
                keyboardType: TextInputType.number,
                inputFormatters: [digitFormatter],
                onChanged: (_) => _onQuantityChanged(),
                prefixIcon: Icons.inventory_2_outlined,
              ),
            ),
            SizedBox(width: AppSizes.p12),
            Expanded(
              child: CustomTextField(
                fieldKey: Key('${widget.keyPrefix}-pieces-field'),
                label: 'عدد القطع',
                hint: '0',
                controller: _piecesController,
                keyboardType: TextInputType.number,
                inputFormatters: [digitFormatter],
                onChanged: (_) => _onQuantityChanged(),
                prefixIcon: Icons.widgets_outlined,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.h12),
        Container(
          padding: EdgeInsets.all(AppSizes.p12),
          decoration: BoxDecoration(
            color: AppColors.infoBackground,
            borderRadius: BorderRadius.circular(AppSizes.r12),
          ),
          child: Text(
            'الإجمالي: $totalPieces قطعة'
            ' • الكرتونة = ${widget.itemsPerCarton} قطعة',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
