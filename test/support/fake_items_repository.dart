import 'dart:async';

import 'package:stock_take/core/models/inventory_item.dart';
import 'package:stock_take/features/items/data/models/new_inventory_item_draft.dart';
import 'package:stock_take/features/items/data/repositories/items_repository_base.dart';

class FakeItemsRepository implements ItemsRepositoryBase {
  final StreamController<List<InventoryItem>> _controller =
      StreamController<List<InventoryItem>>.broadcast();
  final List<InventoryItem> _items;
  late int _lastItemNumber;

  FakeItemsRepository({List<InventoryItem>? items})
    : _items = [...(items ?? sampleInventoryItems)] {
    _lastItemNumber = _items
        .where((item) => item.code.startsWith('S-N-'))
        .map((item) => item.codeNumber ?? 0)
        .fold(0, (maximum, number) => number > maximum ? number : maximum);
  }

  @override
  Stream<List<InventoryItem>> watchActiveItems() async* {
    yield _activeItems;
    yield* _controller.stream;
  }

  @override
  Future<InventoryItem> addItem(NewInventoryItemDraft draft) async {
    _lastItemNumber += 1;
    final code = 'S-N-$_lastItemNumber';
    final item = InventoryItem(
      id: code,
      code: code,
      name: draft.name,
      unit: 'piece',
      itemsPerCarton: draft.itemsPerCarton,
      openingStockPieces: draft.openingStockPieces,
      currentStockPieces: draft.openingStockPieces,
      totalInboundPieces: 0,
      totalOutboundPieces: 0,
      totalCustomerReturnPieces: 0,
      totalSupplierReturnPieces: 0,
      totalAdjustmentPieces: 0,
      active: true,
    );

    _items.add(item);
    _controller.add(_activeItems);
    return item;
  }

  List<InventoryItem> get items => List.unmodifiable(_items);

  List<InventoryItem> get _activeItems {
    final activeItems = _items.where((item) => item.active).toList()
      ..sort((first, second) => first.name.compareTo(second.name));
    return List.unmodifiable(activeItems);
  }

  Future<void> close() => _controller.close();
}

const sampleInventoryItems = <InventoryItem>[
  InventoryItem(
    id: '1',
    code: 'ITM-001',
    name: 'زيت دوار الشمس',
    unit: 'piece',
    itemsPerCarton: 12,
    openingStockPieces: 120,
    currentStockPieces: 120,
    totalInboundPieces: 0,
    totalOutboundPieces: 0,
    totalCustomerReturnPieces: 0,
    totalSupplierReturnPieces: 0,
    totalAdjustmentPieces: 0,
    active: true,
  ),
  InventoryItem(
    id: '2',
    code: 'ITM-002',
    name: 'أرز مصري',
    unit: 'piece',
    itemsPerCarton: 10,
    openingStockPieces: 80,
    currentStockPieces: 80,
    totalInboundPieces: 0,
    totalOutboundPieces: 0,
    totalCustomerReturnPieces: 0,
    totalSupplierReturnPieces: 0,
    totalAdjustmentPieces: 0,
    active: true,
  ),
  InventoryItem(
    id: '3',
    code: 'ITM-003',
    name: 'سكر أبيض',
    unit: 'piece',
    itemsPerCarton: 20,
    openingStockPieces: 45,
    currentStockPieces: 45,
    totalInboundPieces: 0,
    totalOutboundPieces: 0,
    totalCustomerReturnPieces: 0,
    totalSupplierReturnPieces: 0,
    totalAdjustmentPieces: 0,
    active: true,
  ),
  InventoryItem(
    id: '4',
    code: 'ITM-004',
    name: 'مياه معدنية',
    unit: 'piece',
    itemsPerCarton: 24,
    openingStockPieces: 28,
    currentStockPieces: 28,
    totalInboundPieces: 0,
    totalOutboundPieces: 0,
    totalCustomerReturnPieces: 0,
    totalSupplierReturnPieces: 0,
    totalAdjustmentPieces: 0,
    active: true,
  ),
];
