class StocktakeRepositoryFailure implements Exception {
  final String message;

  const StocktakeRepositoryFailure(this.message);

  @override
  String toString() => message;
}
