import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/items/cubit/item_catalog_cubit.dart';
import 'package:stock_take/features/items/cubit/item_catalog_state.dart';

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
          'ITM-001',
        ),
      ),
    );
    await repository.addItem(sampleInventoryItems.first);
    await updatedCatalog;
  });
}
