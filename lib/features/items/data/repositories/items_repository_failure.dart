class ItemsRepositoryFailure implements Exception {
  final String message;

  const ItemsRepositoryFailure(this.message);

  @override
  String toString() => message;
}
