import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/items/cubit/item_catalog_cubit.dart';
import 'package:stock_take/features/items/cubit/item_catalog_state.dart';
import 'package:stock_take/features/items/data/models/new_inventory_item_draft.dart';

import '../../../support/fake_items_repository.dart';

void main() {
  test('publishes catalog updates without reloading the screen', () async {
    final repository = FakeItemsRepository(items: const []);
    final cubit = ItemCatalogCubit(repository);
    addTearDown(cubit.close);
    addTearDown(repository.close);

    final initialCatalog = expectLater(
      cubit.stream,
      emitsThrough(
        isA<ItemCatalogSuccess>().having(
          (state) => state.items,
          'items',
          isEmpty,
        ),
      ),
    );
    cubit.loadItems();
    await initialCatalog;

    final updatedCatalog = expectLater(
      cubit.stream,
      emitsThrough(
        isA<ItemCatalogSuccess>().having(
          (state) => state.items.single.code,
          'new item code',
          'S-N-1',
        ),
      ),
    );
    await repository.addItem(
      const NewInventoryItemDraft(
        name: 'زيت دوار الشمس',
        itemsPerCarton: 12,
        openingStockPieces: 120,
      ),
    );
    await updatedCatalog;
  });
}
