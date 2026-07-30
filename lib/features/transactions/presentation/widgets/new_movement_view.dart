import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/inventory_item.dart';
import '../../../../core/shared_widgets/custom_app_bar.dart';
import '../../../items/cubit/item_catalog_cubit.dart';
import '../../../items/cubit/item_catalog_state.dart';
import '../../../printing/presentation/widgets/printer_setup_button.dart';
import 'current_voucher_panel.dart';
import 'movement_type_selector.dart';
import 'movement_ui_types.dart';
import 'secondary_operations_bar.dart';
import 'selectable_item_card.dart';

/// Renders the responsive movement workspace and forwards user intent.
///
/// The route screen owns draft lifecycle, dialogs, navigation, and persistence
/// orchestration. This widget owns layout and state rendering only.
class NewMovementView extends StatelessWidget {
  final MovementKind movementKind;
  final String searchQuery;
  final Map<String, MovementLineViewData> selectedLines;
  final List<MovementLineViewData> orderedLines;
  final ValueChanged<MovementKind> onMovementKindChanged;
  final VoidCallback onWarehouseReturnTap;
  final VoidCallback onStocktakeTap;
  final VoidCallback onAddItem;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<InventoryItem> onItemTap;
  final ValueChanged<MovementLineViewData> onEditLine;
  final ValueChanged<MovementLineViewData> onRemoveLine;
  final VoidCallback onContinue;
  final VoidCallback onOpenMobileVoucher;

  const NewMovementView({
    super.key,
    required this.movementKind,
    required this.searchQuery,
    required this.selectedLines,
    required this.orderedLines,
    required this.onMovementKindChanged,
    required this.onWarehouseReturnTap,
    required this.onStocktakeTap,
    required this.onAddItem,
    required this.onSearchChanged,
    required this.onItemTap,
    required this.onEditLine,
    required this.onRemoveLine,
    required this.onContinue,
    required this.onOpenMobileVoucher,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.newMovementTitle,
        actions: [PrinterSetupButton()],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _MovementInventoryNotice(movementKind: movementKind),
            SizedBox(height: AppSizes.h12),
            MovementTypeSelector(
              selectedKind: movementKind,
              onChanged: onMovementKindChanged,
            ),
            SizedBox(height: AppSizes.h12),
            SecondaryOperationsBar(
              onWarehouseReturnTap: onWarehouseReturnTap,
              onStocktakeTap: onStocktakeTap,
            ),
            SizedBox(height: AppSizes.h12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemsPane = _ItemsPane(
                    searchQuery: searchQuery,
                    selectedLines: selectedLines,
                    onAddItem: onAddItem,
                    onSearchChanged: onSearchChanged,
                    onItemTap: onItemTap,
                  );
                  if (constraints.maxWidth < 900) {
                    return itemsPane;
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 2, child: itemsPane),
                      SizedBox(width: AppSizes.p16),
                      SizedBox(
                        width: 350,
                        child: CurrentVoucherPanel(
                          movementKind: movementKind,
                          lines: orderedLines,
                          onEdit: onEditLine,
                          onRemove: onRemoveLine,
                          onContinue: onContinue,
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
      bottomNavigationBar: _MobileVoucherSummary(
        itemCount: selectedLines.length,
        onPressed: onOpenMobileVoucher,
      ),
    );
  }
}

class _MovementInventoryNotice extends StatelessWidget {
  final MovementKind movementKind;

  const _MovementInventoryNotice({required this.movementKind});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              movementKind == MovementKind.inbound
                  ? 'الوارد متصل بالمخزون: الحفظ يزيد الرصيد بعد نجاح العملية.'
                  : 'المنصرف متصل بالمخزون: الحفظ يخصم ذريًا ولن يسمح برصيد سالب.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.info),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemsPane extends StatelessWidget {
  final String searchQuery;
  final Map<String, MovementLineViewData> selectedLines;
  final VoidCallback onAddItem;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<InventoryItem> onItemTap;

  const _ItemsPane({
    required this.searchQuery,
    required this.selectedLines,
    required this.onAddItem,
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
        SizedBox(height: AppSizes.h8),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: OutlinedButton.icon(
            key: const Key('add-new-item-from-movement'),
            onPressed: onAddItem,
            icon: const Icon(Icons.add_box_outlined),
            label: const Text('تعريف صنف جديد'),
          ),
        ),
        SizedBox(height: AppSizes.h8),
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
                  .where((item) => item.matchesSearch(normalizedQuery))
                  .toList(growable: false);
              if (visibleItems.isEmpty) {
                return const _NoMatchingItems();
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

class _NoMatchingItems extends StatelessWidget {
  const _NoMatchingItems();

  @override
  Widget build(BuildContext context) {
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
          Text('لا يوجد صنف مطابق للبحث.', style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }
}

class _MobileVoucherSummary extends StatelessWidget {
  final int itemCount;
  final VoidCallback onPressed;

  const _MobileVoucherSummary({
    required this.itemCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.receipt_long_outlined),
              SizedBox(width: AppSizes.p8),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'الإذن الحالي: ${_itemCountLabel(itemCount)}',
                    style: AppTextStyles.buttonText,
                  ),
                ),
              ),
            ],
          ),
        ),
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
