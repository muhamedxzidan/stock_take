class CartonPieceQuantity {
  final int cartons;
  final int pieces;

  const CartonPieceQuantity({required this.cartons, required this.pieces});

  factory CartonPieceQuantity.fromTotalPieces({
    required int totalPieces,
    required int itemsPerCarton,
  }) {
    if (totalPieces < 0 || itemsPerCarton <= 0) {
      throw ArgumentError(
        'totalPieces must be non-negative and itemsPerCarton must be positive.',
      );
    }

    return CartonPieceQuantity(
      cartons: totalPieces ~/ itemsPerCarton,
      pieces: totalPieces % itemsPerCarton,
    );
  }

  int totalPiecesFor(int itemsPerCarton) => (cartons * itemsPerCarton) + pieces;

  String get cartonFirstLabel {
    final loosePiecesLabel = pieces > 0 ? ' + $pieces قطعة' : '';
    return '$cartons كرتونة$loosePiecesLabel';
  }
}
