import '../data/models/transaction_model.dart';

sealed class TransactionsState {}

class TransactionsInitial extends TransactionsState {}

class TransactionsLoading extends TransactionsState {}

class TransactionsSuccess extends TransactionsState {
  final List<TransactionModel> transactions;
  final TransactionType? selectedFilter;

  TransactionsSuccess({
    required this.transactions,
    this.selectedFilter,
  });
}

class TransactionsFailure extends TransactionsState {
  final String message;

  TransactionsFailure(this.message);
}
