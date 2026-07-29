import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/core/models/carton_piece_quantity.dart';

void main() {
  test('converts total pieces to a carton-first quantity', () {
    final quantity = CartonPieceQuantity.fromTotalPieces(
      totalPieces: 26,
      itemsPerCarton: 12,
    );

    expect(quantity.cartons, 2);
    expect(quantity.pieces, 2);
    expect(quantity.cartonFirstLabel, '2 كرتونة + 2 قطعة');
  });

  test('keeps loose pieces visible after the primary carton count', () {
    final quantity = CartonPieceQuantity.fromTotalPieces(
      totalPieces: 3,
      itemsPerCarton: 12,
    );

    expect(quantity.cartonFirstLabel, '0 كرتونة + 3 قطعة');
    expect(quantity.totalPiecesFor(12), 3);
  });
}
