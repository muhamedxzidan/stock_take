class CartonPieceQuantity {
  final int cartons;
  final int pieces;

  const CartonPieceQuantity({required this.cartons, required this.pieces});

  int totalPiecesFor(int itemsPerCarton) => (cartons * itemsPerCarton) + pieces;
}
