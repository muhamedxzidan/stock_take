import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/stocktake_line.dart';
import '../data/models/stocktake_session.dart';
import '../data/repositories/stocktake_repository_base.dart';
import '../data/repositories/stocktake_repository_failure.dart';
import 'stocktake_draft_validator.dart';
import 'stocktake_state.dart';

class StocktakeCubit extends Cubit<StocktakeState> {
  final StocktakeRepositoryBase _repository;
  final Duration _loadTimeout;
  StreamSubscription<List<StocktakeLine>>? _linesSubscription;
  bool _isActing = false;
  int _loadGeneration = 0;

  StocktakeCubit(
    this._repository, {
    Duration loadTimeout = const Duration(seconds: 15),
  }) : _loadTimeout = loadTimeout,
       super(const StocktakeInitial());

  Future<void> load() async {
    final generation = ++_loadGeneration;
    await _linesSubscription?.cancel();
    _linesSubscription = null;
    if (isClosed || generation != _loadGeneration) {
      return;
    }
    emit(const StocktakeLoading());
    try {
      final session = await _repository.fetchOpenStocktake().timeout(
        _loadTimeout,
      );
      if (isClosed || generation != _loadGeneration) {
        return;
      }
      if (session == null) {
        emit(const StocktakeReady(session: null, lines: []));
        return;
      }
      await _watchLines(session, generation: generation);
    } on TimeoutException {
      if (!isClosed && generation == _loadGeneration) {
        emit(
          const StocktakeFailure(
            session: null,
            lines: [],
            message: 'استغرق تحميل الجرد وقتًا أطول من المتوقع. حاول مرة أخرى.',
          ),
        );
      }
    } on StocktakeRepositoryFailure catch (failure) {
      if (!isClosed && generation == _loadGeneration) {
        emit(
          StocktakeFailure(
            session: null,
            lines: const [],
            message: failure.message,
          ),
        );
      }
    } catch (_) {
      if (!isClosed && generation == _loadGeneration) {
        emit(
          const StocktakeFailure(
            session: null,
            lines: [],
            message: 'تعذر تحميل جلسة الجرد الآن.',
          ),
        );
      }
    }
  }

  Future<bool> startStocktake(StartStocktakeDraft draft) async {
    if (_isActing) {
      return false;
    }

    final validationMessage = StocktakeDraftValidator.validate(draft);
    if (validationMessage != null) {
      emit(
        StocktakeFailure(
          session: null,
          lines: const [],
          message: validationMessage,
        ),
      );
      return false;
    }

    _isActing = true;
    emit(
      const StocktakeActionInProgress(
        session: null,
        lines: [],
        action: StocktakeAction.starting,
      ),
    );
    try {
      final session = await _repository.startStocktake(draft);
      await _watchLines(session, generation: _loadGeneration);
      return true;
    } on StocktakeRepositoryFailure catch (failure) {
      emit(
        StocktakeFailure(
          session: null,
          lines: const [],
          message: failure.message,
        ),
      );
      return false;
    } catch (_) {
      emit(
        const StocktakeFailure(
          session: null,
          lines: [],
          message: 'تعذر بدء جلسة الجرد الآن.',
        ),
      );
      return false;
    } finally {
      _isActing = false;
    }
  }

  Future<bool> saveCount({
    required String itemId,
    required int actualQuantityPieces,
  }) async {
    final readyState = _readyState;
    final session = readyState?.session;
    if (_isActing || readyState == null || session == null) {
      return false;
    }
    if (actualQuantityPieces < 0) {
      emit(
        StocktakeFailure(
          session: session,
          lines: readyState.lines,
          message: 'العدد الفعلي لا يمكن أن يكون سالبًا.',
        ),
      );
      return false;
    }

    _isActing = true;
    emit(
      StocktakeActionInProgress(
        session: session,
        lines: readyState.lines,
        action: StocktakeAction.savingCount,
        itemId: itemId,
      ),
    );
    try {
      await _repository.saveCount(
        stocktakeId: session.id,
        itemId: itemId,
        actualQuantityPieces: actualQuantityPieces,
      );
      final updatedLines = readyState.lines
          .map(
            (line) => line.itemId == itemId
                ? line.copyWith(
                    actualQuantityPieces: actualQuantityPieces,
                    differencePieces:
                        actualQuantityPieces - line.systemQuantityPieces,
                    counted: true,
                    countedAt: DateTime.now(),
                  )
                : line,
          )
          .toList(growable: false);
      emit(StocktakeReady(session: session, lines: updatedLines));
      return true;
    } on StocktakeRepositoryFailure catch (failure) {
      emit(
        StocktakeFailure(
          session: session,
          lines: readyState.lines,
          message: failure.message,
        ),
      );
      return false;
    } catch (_) {
      emit(
        StocktakeFailure(
          session: session,
          lines: readyState.lines,
          message: 'تعذر حفظ العدد الفعلي الآن.',
        ),
      );
      return false;
    } finally {
      _isActing = false;
    }
  }

  Future<SavedStocktakeCompletion?> completeStocktake() async {
    final readyState = _readyState;
    final session = readyState?.session;
    if (_isActing || readyState == null || session == null) {
      return null;
    }
    if (readyState.lines.isEmpty ||
        readyState.lines.any((line) => !line.counted)) {
      emit(
        StocktakeFailure(
          session: session,
          lines: readyState.lines,
          message: 'احفظ العدد الفعلي لكل الأصناف قبل اعتماد الجرد.',
        ),
      );
      return null;
    }

    _isActing = true;
    emit(
      StocktakeActionInProgress(
        session: session,
        lines: readyState.lines,
        action: StocktakeAction.completing,
      ),
    );
    try {
      final completion = await _repository.completeStocktake(session.id);
      await _linesSubscription?.cancel();
      _linesSubscription = null;
      emit(StocktakeCompleted(completion: completion));
      return completion;
    } on StocktakeRepositoryFailure catch (failure) {
      emit(
        StocktakeFailure(
          session: session,
          lines: readyState.lines,
          message: failure.message,
        ),
      );
      return null;
    } catch (_) {
      emit(
        StocktakeFailure(
          session: session,
          lines: readyState.lines,
          message: 'تعذر اعتماد جلسة الجرد الآن.',
        ),
      );
      return null;
    } finally {
      _isActing = false;
    }
  }

  Future<bool> cancelStocktake() async {
    final readyState = _readyState;
    final session = readyState?.session;
    if (_isActing || readyState == null || session == null) {
      return false;
    }

    _isActing = true;
    emit(
      StocktakeActionInProgress(
        session: session,
        lines: readyState.lines,
        action: StocktakeAction.cancelling,
      ),
    );
    try {
      await _repository.cancelStocktake(session.id);
      await _linesSubscription?.cancel();
      _linesSubscription = null;
      emit(StocktakeCancelled(stocktakeNumber: session.stocktakeNumber));
      return true;
    } on StocktakeRepositoryFailure catch (failure) {
      emit(
        StocktakeFailure(
          session: session,
          lines: readyState.lines,
          message: failure.message,
        ),
      );
      return false;
    } catch (_) {
      emit(
        StocktakeFailure(
          session: session,
          lines: readyState.lines,
          message: 'تعذر إلغاء جلسة الجرد الآن.',
        ),
      );
      return false;
    } finally {
      _isActing = false;
    }
  }

  Future<void> _watchLines(
    StocktakeSession session, {
    required int generation,
  }) async {
    await _linesSubscription?.cancel();
    final firstSnapshot = Completer<void>();
    late final StreamSubscription<List<StocktakeLine>> subscription;
    subscription = _repository
        .watchLines(session.id)
        .listen(
          (lines) {
            if (!firstSnapshot.isCompleted) {
              firstSnapshot.complete();
            }
            if (!isClosed && generation == _loadGeneration) {
              emit(StocktakeReady(session: session, lines: lines));
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            if (!firstSnapshot.isCompleted) {
              firstSnapshot.completeError(error, stackTrace);
            }
            if (!isClosed && generation == _loadGeneration) {
              final message = error is StocktakeRepositoryFailure
                  ? error.message
                  : 'تعذر تحميل أصناف جلسة الجرد.';
              emit(
                StocktakeFailure(
                  session: session,
                  lines: _currentLinesFor(session),
                  message: message,
                ),
              );
            }
          },
          onDone: () {
            if (!firstSnapshot.isCompleted) {
              firstSnapshot.completeError(
                const StocktakeRepositoryFailure(
                  'انقطع الاتصال بجلسة الجرد قبل تحميل الأصناف.',
                ),
              );
            } else if (!isClosed && generation == _loadGeneration) {
              emit(
                StocktakeFailure(
                  session: session,
                  lines: _currentLinesFor(session),
                  message: 'انقطع الاتصال بتحديثات جلسة الجرد.',
                ),
              );
            }
          },
        );
    _linesSubscription = subscription;
    try {
      await firstSnapshot.future.timeout(_loadTimeout);
    } on TimeoutException {
      if (identical(_linesSubscription, subscription)) {
        await subscription.cancel();
        _linesSubscription = null;
      }
      rethrow;
    }
  }

  List<StocktakeLine> _currentLinesFor(StocktakeSession session) {
    final readyState = _readyState;
    return readyState?.session?.id == session.id ? readyState!.lines : const [];
  }

  StocktakeReady? get _readyState {
    final current = state;
    return current is StocktakeReady ? current : null;
  }

  @override
  Future<void> close() async {
    _loadGeneration += 1;
    await _linesSubscription?.cancel();
    return super.close();
  }
}
