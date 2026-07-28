import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/inventory_item.dart';
import '../data/repositories/items_repository_base.dart';
import 'item_catalog_state.dart';

class ItemCatalogCubit extends Cubit<ItemCatalogState> {
  final ItemsRepositoryBase _repository;
  StreamSubscription<List<InventoryItem>>? _subscription;

  ItemCatalogCubit(this._repository) : super(const ItemCatalogInitial());

  void loadItems() {
    if (_subscription != null) {
      return;
    }

    emit(const ItemCatalogLoading());
    _subscription = _repository.watchActiveItems().listen(
      (items) => emit(ItemCatalogSuccess(List.unmodifiable(items))),
      onError: (_) {
        _subscription?.cancel();
        _subscription = null;
        emit(
          const ItemCatalogFailure(
            'تعذر تحميل الأصناف. تحقق من الإنترنت وحاول مرة أخرى.',
          ),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
