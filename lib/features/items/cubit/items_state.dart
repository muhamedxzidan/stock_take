sealed class ItemsState {}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsSuccess extends ItemsState {}

class ItemsFailure extends ItemsState {
  final String message;

  ItemsFailure(this.message);
}
