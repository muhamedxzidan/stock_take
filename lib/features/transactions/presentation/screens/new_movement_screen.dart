import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/inventory_item.dart';
import '../../../../core/shared_widgets/custom_app_bar.dart';
import '../../../items/cubit/item_catalog_cubit.dart';
import '../../../items/cubit/item_catalog_state.dart';
import '../widgets/current_voucher_panel.dart';
import '../widgets/item_quantity_sheet.dart';
import '../widgets/movement_details_sheet.dart';
import '../widgets/movement_type_selector.dart';
import '../widgets/movement_ui_types.dart';
import '../widgets/movement_voucher_preview_dialog.dart';
import '../widgets/secondary_operations_bar.dart';
import '../widgets/selectable_item_card.dart';

class NewMovementScreen extends StatefulWidget {
  const NewMovementScreen({super.key});

  @override
  State<NewMovementScreen> createState() => _NewMovementScreenState();
}

class _NewMovementScreenState extends State<NewMovementScreen> {
  MovementKind _movementKind = MovementKind.inbound;
  final Map<String, MovementLineViewData> _lines = {};
  String _searchQuery = '';

  List<MovementLineViewData> get _orderedLines =>
      _lines.values.toList(growable: false);

  @override
  void initState() {
    super.initState();
    context.read<ItemCatalogCubit>().loadItems();
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

    await showDialog<void>(
      context: context,
      builder: (context) => MovementVoucherPreviewDialog(
        movementKind: _movementKind,
        lines: _orderedLines,
        details: details,
      ),
    );
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
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.newMovementTitle),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.p12,
                vertical: AppSizes.p8,
              ),
              decoration: BoxDecoration(
                color: AppColors.infoBackground,
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.info),
                  SizedBox(width: AppSizes.p8),
                  Expanded(
                    child: Text(
                      'واجهة تجريبية فقط؛ لن يتم حفظ البيانات أو تعديل الرصيد.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.h12),
            MovementTypeSelector(
              selectedKind: _movementKind,
              onChanged: _changeMovementKind,
            ),
            SizedBox(height: AppSizes.h12),
            SecondaryOperationsBar(
              onWarehouseReturnTap: () {
                context.go(AppRoutes.warehouseReturn);
              },
              onStocktakeTap: () {
                context.go(AppRoutes.stockAdjustment);
              },
            ),
            SizedBox(height: AppSizes.h12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 900;
                  final itemsPane = _ItemsPane(
                    searchQuery: _searchQuery,
                    selectedLines: _lines,
                    onSearchChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                    onItemTap: _openQuantityPicker,
                  );

                  if (!isWide) return itemsPane;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 2, child: itemsPane),
                      SizedBox(width: AppSizes.p16),
                      SizedBox(
                        width: 350,
                        child: CurrentVoucherPanel(
                          movementKind: _movementKind,
                          lines: _orderedLines,
                          onEdit: (line) => _openQuantityPicker(line.item),
                          onRemove: _removeLine,
                          onContinue: _openDetailsAndPreview,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (MediaQuery.sizeOf(context).width >= 900) {
            return const SizedBox.shrink();
          }

          return SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.p16,
                AppSizes.p4,
                AppSizes.p16,
                AppSizes.p8,
              ),
              child: FilledButton(
                key: const Key('mobile-voucher-summary'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: Size(double.infinity, AppSizes.buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                  ),
                ),
                onPressed: _openMobileVoucher,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.receipt_long_outlined),
                    SizedBox(width: AppSizes.p8),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'الإذن الحالي: ${_itemCountLabel(_lines.length)}',
                          style: AppTextStyles.buttonText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _itemCountLabel(int count) {
    if (count == 0) return 'فارغ';
    if (count == 1) return 'صنف واحد';
    if (count == 2) return 'صنفان';
    return '$count أصناف';
  }
}

class _ItemsPane extends StatelessWidget {
  final String searchQuery;
  final Map<String, MovementLineViewData> selectedLines;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<InventoryItem> onItemTap;

  const _ItemsPane({
    required this.searchQuery,
    required this.selectedLines,
    required this.onSearchChanged,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const Key('movement-item-search'),
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: AppStrings.searchHint,
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: searchQuery.isEmpty
                ? null
                : const Icon(Icons.filter_alt_outlined),
          ),
        ),
        SizedBox(height: AppSizes.h12),
        Expanded(
          child: BlocBuilder<ItemCatalogCubit, ItemCatalogState>(
            builder: (context, state) {
              if (state is ItemCatalogLoading || state is ItemCatalogInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ItemCatalogFailure) {
                return Center(
                  child: Text(state.message, style: AppTextStyles.bodyLarge),
                );
              }
              if (state is! ItemCatalogSuccess) {
                return const SizedBox.shrink();
              }

              final normalizedQuery = searchQuery.trim().toLowerCase();
              final visibleItems = state.items
                  .where((item) {
                    if (normalizedQuery.isEmpty) return true;
                    return item.name.toLowerCase().contains(normalizedQuery) ||
                        item.code.toLowerCase().contains(normalizedQuery);
                  })
                  .toList(growable: false);

              if (visibleItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.search_off_rounded,
                        size: 48,
                        color: AppColors.textLight,
                      ),
                      SizedBox(height: AppSizes.h12),
                      Text(
                        'لا يوجد صنف مطابق للبحث.',
                        style: AppTextStyles.bodyLarge,
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                itemCount: visibleItems.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 360,
                  mainAxisExtent: 176,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final item = visibleItems[index];
                  return SelectableItemCard(
                    item: item,
                    selectedLine: selectedLines[item.id],
                    onTap: () => onItemTap(item),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
