import '../models/transaction_model.dart';

abstract class TransactionsRepositoryBase {
  /// Record a new transaction (Inbound / Outbound / Adjustment).
  Future<void> createTransaction(TransactionModel transaction);

  /// Fetch all historical transactions log.
  Future<List<TransactionModel>> fetchTransactions();
}
