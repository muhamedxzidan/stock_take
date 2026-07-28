class TransactionsRepositoryFailure implements Exception {
  final String message;

  const TransactionsRepositoryFailure(this.message);

  @override
  String toString() => message;
}
