class ReturnsRepositoryFailure implements Exception {
  final String message;

  const ReturnsRepositoryFailure(this.message);

  @override
  String toString() => message;
}
