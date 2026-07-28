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

  test('normalizes the code and publishes the new item immediately', () async {
    await cubit.submitNewItem(
      name: '  مياه معدنية  ',
      code: ' itm-100 ',
      itemsPerCartonStr: '24',
      initialBalanceStr: '48',
    );

    expect(cubit.state, isA<ItemsSuccess>());
    final items = repository.items;
    expect(items, hasLength(1));
    expect(items.single.id, 'ITM-100');
    expect(items.single.code, 'ITM-100');
    expect(items.single.name, 'مياه معدنية');
    expect(items.single.currentStockPieces, 48);
  });

  test(
    'rejects an invalid carton size before calling the repository',
    () async {
      await cubit.submitNewItem(
        name: 'صنف اختبار',
        code: 'ITM-100',
        itemsPerCartonStr: '0',
        initialBalanceStr: '10',
      );

      expect(cubit.state, isA<ItemsFailure>());
      expect(
        (cubit.state as ItemsFailure).message,
        'عدد القطع في الكرتونة يجب أن يكون أكبر من صفر.',
      );
    },
  );

  test('returns a clear failure when the item code already exists', () async {
    await cubit.submitNewItem(
      name: 'الصنف الأول',
      code: 'ITM-100',
      itemsPerCartonStr: '12',
      initialBalanceStr: '0',
    );

    await cubit.submitNewItem(
      name: 'الصنف المكرر',
      code: 'itm-100',
      itemsPerCartonStr: '12',
      initialBalanceStr: '0',
    );

    expect(cubit.state, isA<ItemsFailure>());
    expect((cubit.state as ItemsFailure).message, 'كود الصنف مستخدم بالفعل.');
  });
}
