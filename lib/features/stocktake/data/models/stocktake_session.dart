enum StocktakeStatus { open, completed }

class StocktakeSession {
  final String id;
  final String stocktakeNumber;
  final StocktakeStatus status;
  final DateTime periodFrom;
  final DateTime periodTo;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String notes;

  const StocktakeSession({
    required this.id,
    required this.stocktakeNumber,
    required this.status,
    required this.periodFrom,
    required this.periodTo,
    required this.startedAt,
    required this.completedAt,
    required this.notes,
  });
}

class StartStocktakeDraft {
  final DateTime periodFrom;
  final DateTime periodTo;
  final String notes;

  const StartStocktakeDraft({
    required this.periodFrom,
    required this.periodTo,
    required this.notes,
  });
}

class SavedStocktakeCompletion {
  final String stocktakeNumber;
  final String? movementVoucherNumber;
  final int adjustedItemCount;
  final int netDifferencePieces;

  const SavedStocktakeCompletion({
    required this.stocktakeNumber,
    required this.movementVoucherNumber,
    required this.adjustedItemCount,
    required this.netDifferencePieces,
  });
}
