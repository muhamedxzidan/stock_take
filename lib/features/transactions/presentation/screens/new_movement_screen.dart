import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/models/inventory_item.dart';
import '../../../items/cubit/item_catalog_cubit.dart';
import '../../../printing/presentation/widgets/thermal_receipt_dialog.dart';
import '../../data/mappers/movement_receipt_mapper.dart';
import '../../data/models/inventory_movement.dart';
import '../widgets/current_voucher_panel.dart';
import '../widgets/item_quantity_sheet.dart';
import '../widgets/movement_details_sheet.dart';
import '../widgets/movement_ui_types.dart';
import '../widgets/movement_voucher_preview_dialog.dart';
import '../widgets/new_movement_view.dart';

class NewMovementScreen extends StatefulWidget {
  final MovementKind initialMovementKind;

  const NewMovementScreen({
    super.key,
    this.initialMovementKind = MovementKind.inbound,
  });

  @override
  State<NewMovementScreen> createState() => _NewMovementScreenState();
}

class _NewMovementScreenState extends State<NewMovementScreen> {
  late MovementKind _movementKind;
  final Map<String, MovementLineViewData> _lines = {};
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
  _movementSavedSnackBar;
  String _searchQuery = '';

  List<MovementLineViewData> get _orderedLines =>
      _lines.values.toList(growable: false);

  @override
  void initState() {
    super.initState();
    _movementKind = widget.initialMovementKind;
    context.read<ItemCatalogCubit>().loadItems();
  }

  @override
  void dispose() {
    _movementSavedSnackBar?.close();
    super.dispose();
  }

  Future<void> _changeMovementKind(MovementKind nextKind) async {
    if (nextKind == _movementKind) return;

    if (_lines.isNotEmpty) {
      final shouldChange = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تغيير نوع الحركة؟'),
          content: const Text('سيتم تفريغ الأصناف الموجودة في الإذن الحالي.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('تغيير وتفريغ الإذن'),
            ),
          ],
        ),
      );
      if (shouldChange != true || !mounted) return;
    }

    setState(() {
      _movementKind = nextKind;
      _lines.clear();
    });
  }

  Future<void> _openQuantityPicker(InventoryItem item) async {
    final currentLine = _lines[item.id];
    final selection = await showModalBottomSheet<QuantitySelection>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.background,
      showDragHandle: false,
      builder: (context) => ItemQuantitySheet(
        item: item,
        movementKind: _movementKind,
        initialSelection: QuantitySelection(
          cartons: currentLine?.cartons ?? 0,
          pieces: currentLine?.pieces ?? 0,
        ),
      ),
    );

    if (selection == null || !mounted) return;

    setState(() {
      _lines[item.id] = MovementLineViewData(
        item: item,
        cartons: selection.cartons,
        pieces: selection.pieces,
      );
    });
  }

  void _removeLine(MovementLineViewData line) {
    setState(() => _lines.remove(line.item.id));
  }

  Future<void> _openDetailsAndPreview() async {
    if (_lines.isEmpty) return;

    final details = await showModalBottomSheet<MovementVoucherDetails>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.background,
      showDragHandle: false,
      builder: (context) => MovementDetailsSheet(movementKind: _movementKind),
    );

    if (details == null || !mounted) return;

    final businessDate = DateTime.tryParse(details.date);
    if (businessDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اكتب التاريخ بصيغة صحيحة مثل 2026-07-28.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final movementDraft = InventoryMovementDraft(
      lines: _orderedLines
          .map(
            (line) => InventoryMovementLine(
              itemId: line.item.id,
              itemCode: line.item.code,
              itemName: line.item.name,
              unit: line.item.unit,
              itemsPerCarton: line.item.itemsPerCarton,
              cartons: line.cartons,
              pieces: line.pieces,
            ),
          )
          .toList(growable: false),
      partyName: details.partyName,
      deliveredBy: details.deliveredBy,
      receivedBy: details.receivedBy,
      driverName: details.driverName,
      notes: details.notes,
      businessDate: businessDate,
    );

    final savedMovement = await showDialog<SavedInventoryMovement>(
      context: context,
      builder: (context) => MovementVoucherPreviewDialog(
        movementKind: _movementKind,
        lines: _orderedLines,
        details: details,
        movementDraft: movementDraft,
      ),
    );
    if (savedMovement == null || !mounted) return;

    final receipt = MovementReceiptMapper.fromSavedMovement(
      savedMovement: savedMovement,
      draft: movementDraft,
      movementLabel: 'إذن ${_movementKind.label}',
      partyLabel: _movementKind == MovementKind.inbound
          ? 'المورد'
          : 'الجهة المستلمة',
    );
    setState(() => _lines.clear());
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    final controller = messenger.showSnackBar(
      SnackBar(
        key: const Key('movement-saved-snackbar'),
        duration: const Duration(seconds: 4),
        content: Text(
          'تم حفظ إذن ${_movementKind.voucherLabel} '
          '${savedMovement.voucherNumber}. '
          'يمكن إعادة الطباعة من سجل الحركات.',
        ),
        backgroundColor: AppColors.success,
      ),
    );
    _movementSavedSnackBar = controller;
    controller.closed.whenComplete(() {
      if (identical(_movementSavedSnackBar, controller)) {
        _movementSavedSnackBar = null;
      }
    });

    await ThermalReceiptDialog.show(context, receipt: receipt);
  }

  void _openMobileVoucher() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.background,
      builder: (context) => SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.78,
        child: Padding(
          padding: EdgeInsets.all(AppSizes.p16),
          child: CurrentVoucherPanel(
            movementKind: _movementKind,
            lines: _orderedLines,
            onEdit: (line) {
              Navigator.pop(context);
              _openQuantityPicker(line.item);
            },
            onRemove: (line) {
              Navigator.pop(context);
              _removeLine(line);
            },
            onContinue: () {
              Navigator.pop(context);
              _openDetailsAndPreview();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NewMovementView(
      movementKind: _movementKind,
      searchQuery: _searchQuery,
      selectedLines: _lines,
      orderedLines: _orderedLines,
      onMovementKindChanged: _changeMovementKind,
      onWarehouseReturnTap: () => context.go(AppRoutes.warehouseReturn),
      onStocktakeTap: () => context.go(AppRoutes.stockAdjustment),
      onAddItem: () => context.push(AppRoutes.addItem),
      onSearchChanged: (value) => setState(() => _searchQuery = value),
      onItemTap: _openQuantityPicker,
      onEditLine: (line) => _openQuantityPicker(line.item),
      onRemoveLine: _removeLine,
      onContinue: _openDetailsAndPreview,
      onOpenMobileVoucher: _openMobileVoucher,
    );
  }
}
