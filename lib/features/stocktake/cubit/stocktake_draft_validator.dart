import '../data/models/stocktake_session.dart';

/// Owns the business validation required before a stocktake session is opened.
class StocktakeDraftValidator {
  const StocktakeDraftValidator._();

  static String? validate(StartStocktakeDraft draft, {DateTime? now}) {
    final from = DateTime(
      draft.periodFrom.year,
      draft.periodFrom.month,
      draft.periodFrom.day,
    );
    final to = DateTime(
      draft.periodTo.year,
      draft.periodTo.month,
      draft.periodTo.day,
    );
    final current = now ?? DateTime.now();
    final today = DateTime(current.year, current.month, current.day);
    if (from.isAfter(to)) {
      return 'تاريخ البداية يجب أن يسبق تاريخ النهاية.';
    }
    if (to.isAfter(today)) {
      return 'لا يمكن بدء جلسة جرد لفترة مستقبلية.';
    }
    if (draft.notes.length > 1000) {
      return 'ملاحظات جلسة الجرد أطول من الحد المسموح.';
    }
    return null;
  }
}
