import '../data/models/stocktake_line.dart';
import '../data/models/stocktake_session.dart';

sealed class StocktakeState {
  const StocktakeState();
}

class StocktakeInitial extends StocktakeState {
  const StocktakeInitial();
}

class StocktakeLoading extends StocktakeState {
  const StocktakeLoading();
}

class StocktakeReady extends StocktakeState {
  final StocktakeSession? session;
  final List<StocktakeLine> lines;

  const StocktakeReady({required this.session, required this.lines});
}

enum StocktakeAction { starting, savingCount, completing, cancelling }

class StocktakeActionInProgress extends StocktakeReady {
  final StocktakeAction action;
  final String? itemId;

  const StocktakeActionInProgress({
    required super.session,
    required super.lines,
    required this.action,
    this.itemId,
  });
}

class StocktakeFailure extends StocktakeReady {
  final String message;

  const StocktakeFailure({
    required super.session,
    required super.lines,
    required this.message,
  });
}

class StocktakeCompleted extends StocktakeReady {
  final SavedStocktakeCompletion completion;

  const StocktakeCompleted({required this.completion})
    : super(session: null, lines: const []);
}

class StocktakeCancelled extends StocktakeReady {
  final String stocktakeNumber;

  const StocktakeCancelled({required this.stocktakeNumber})
    : super(session: null, lines: const []);
}
