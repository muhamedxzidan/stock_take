import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/stocktake/cubit/stocktake_draft_validator.dart';
import 'package:stock_take/features/stocktake/data/models/stocktake_session.dart';

void main() {
  final today = DateTime(2026, 8, 2);

  StartStocktakeDraft draft({DateTime? from, DateTime? to, String notes = ''}) {
    return StartStocktakeDraft(
      periodFrom: from ?? today,
      periodTo: to ?? today,
      notes: notes,
    );
  }

  test('accepts a valid historical or current stocktake period', () {
    expect(
      StocktakeDraftValidator.validate(
        draft(from: DateTime(2026, 8, 1)),
        now: today,
      ),
      isNull,
    );
  });

  test('rejects an inverted, future, or overly long draft', () {
    expect(
      StocktakeDraftValidator.validate(
        draft(from: today, to: DateTime(2026, 8, 1)),
        now: today,
      ),
      contains('البداية'),
    );
    expect(
      StocktakeDraftValidator.validate(
        draft(to: DateTime(2026, 8, 3)),
        now: today,
      ),
      contains('مستقبلية'),
    );
    expect(
      StocktakeDraftValidator.validate(draft(notes: 'a' * 1001), now: today),
      contains('ملاحظات'),
    );
  });
}
