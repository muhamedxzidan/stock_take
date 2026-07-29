import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/items/cubit/items_cubit.dart';
import 'package:stock_take/features/items/cubit/items_state.dart';

import '../../../support/fake_items_repository.dart';

void main() {
  late FakeItemsRepository repository;
  late ItemsCubit cubit;

  setUp(() {
    repository = FakeItemsRepository(items: const []);
    cubit = ItemsCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await repository.close();
  });

  test(
    'generates a short code and publishes the new item immediately',
    () async {
      await cubit.submitNewItem(
        name: '  مياه معدنية  ',
        itemsPerCartonStr: '24',
        openingStockCartons: 2,
        openingStockPieces: 3,
      );

      expect(cubit.state, isA<ItemsSuccess>());
      final items = repository.items;
      expect(items, hasLength(1));
      expect(items.single.id, 'S-N-1');
      expect(items.single.code, 'S-N-1');
      expect(items.single.name, 'مياه معدنية');
      expect(items.single.currentStockPieces, 51);
    },
  );

  test(
    'rejects an invalid carton size before calling the repository',
    () async {
      await cubit.submitNewItem(
        name: 'صنف اختبار',
        itemsPerCartonStr: '0',
        openingStockCartons: 1,
        openingStockPieces: 0,
      );

      expect(cubit.state, isA<ItemsFailure>());
      expect(
        (cubit.state as ItemsFailure).message,
        'عدد القطع في الكرتونة يجب أن يكون أكبر من صفر.',
      );
    },
  );

  test('increments only the numeric part of the generated code', () async {
    await cubit.submitNewItem(
      name: 'الصنف الأول',
      itemsPerCartonStr: '12',
      openingStockCartons: 0,
      openingStockPieces: 0,
    );

    await cubit.submitNewItem(
      name: 'الصنف الثاني',
      itemsPerCartonStr: '12',
      openingStockCartons: 0,
      openingStockPieces: 0,
    );

    expect(repository.items.map((item) => item.code), ['S-N-1', 'S-N-2']);
  });
}
