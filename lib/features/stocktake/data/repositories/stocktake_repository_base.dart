import '../models/stocktake_line.dart';
import '../models/stocktake_session.dart';

abstract class StocktakeRepositoryBase {
  Future<StocktakeSession?> fetchOpenStocktake();

  Stream<List<StocktakeLine>> watchLines(String stocktakeId);

  Future<StocktakeSession> startStocktake(StartStocktakeDraft draft);

  Future<void> saveCount({
    required String stocktakeId,
    required String itemId,
    required int actualQuantityPieces,
  });

  Future<SavedStocktakeCompletion> completeStocktake(String stocktakeId);
}
