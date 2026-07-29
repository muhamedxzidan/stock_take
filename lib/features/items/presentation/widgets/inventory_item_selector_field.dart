import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/inventory_item.dart';
import '../../cubit/item_catalog_cubit.dart';
import '../../cubit/item_catalog_state.dart';

class InventoryItemSelectorField extends StatelessWidget {
  final String label;
  final InventoryItem? selectedItem;
  final ValueChanged<InventoryItem> onSelected;

  const InventoryItemSelectorField({
    super.key,
    required this.selectedItem,
    required this.onSelected,
    this.label = 'الصنف',
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemCatalogCubit, ItemCatalogState>(
      builder: (context, state) {
        final isLoading = state is ItemCatalogLoading;
        final items = state is ItemCatalogSuccess
            ? state.items
            : const <InventoryItem>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSizes.h8),
            InkWell(
              key: const Key('inventory-item-selector'),
              onTap: isLoading || items.isEmpty
                  ? null
                  : () => _openPicker(context, items),
              borderRadius: BorderRadius.circular(AppSizes.r12),
              child: InputDecorator(
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.primary,
                  ),
                  suffixIcon: isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.expand_more_rounded),
                ),
                child: Text(
                  selectedItem == null
                      ? state is ItemCatalogFailure
                            ? state.message
                            : items.isEmpty && !isLoading
                            ? 'لا توجد أصناف متاحة'
                            : 'اختر الصنف'
                      : '${selectedItem!.name} • ${selectedItem!.code}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: selectedItem == null
                        ? AppColors.textLight
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    List<InventoryItem> items,
  ) async {
    final selected = await showModalBottomSheet<InventoryItem>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _InventoryItemPickerSheet(items: items),
    );

    if (selected != null) {
      onSelected(selected);
    }
  }
}

class _InventoryItemPickerSheet extends StatefulWidget {
  final List<InventoryItem> items;

  const _InventoryItemPickerSheet({required this.items});

  @override
  State<_InventoryItemPickerSheet> createState() =>
      _InventoryItemPickerSheetState();
}

class _InventoryItemPickerSheetState extends State<_InventoryItemPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = _query.trim().toLowerCase();
    final visibleItems = widget.items
        .where((item) => item.matchesSearch(normalizedQuery))
        .toList(growable: false);

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.78,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('اختر الصنف', style: AppTextStyles.heading2),
            SizedBox(height: AppSizes.h12),
            TextField(
              key: const Key('inventory-item-search'),
              autofocus: true,
              onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(
                hintText: 'ابحث بالاسم أو الكود أو الرقم',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            SizedBox(height: AppSizes.h12),
            Expanded(
              child: visibleItems.isEmpty
                  ? const Center(child: Text('لا يوجد صنف مطابق'))
                  : ListView.separated(
                      itemCount: visibleItems.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = visibleItems[index];
                        return ListTile(
                          key: Key('inventory-item-option-${item.id}'),
                          title: Text(item.name),
                          subtitle: Text(
                            '${item.code} • ${item.itemsPerCarton} قطعة/كرتونة',
                          ),
                          trailing: Text(item.formattedCartonStock),
                          onTap: () => Navigator.pop(context, item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
