class StocktakeLine {
  final String itemId;
  final String itemNameSnapshot;
  final String itemCodeSnapshot;
  final String unit;
  final int itemsPerCarton;
  final int systemQuantityPieces;
  final int actualQuantityPieces;
  final int differencePieces;
  final bool counted;
  final DateTime? countedAt;

  const StocktakeLine({
    required this.itemId,
    required this.itemNameSnapshot,
    required this.itemCodeSnapshot,
    required this.unit,
    required this.itemsPerCarton,
    required this.systemQuantityPieces,
    required this.actualQuantityPieces,
    required this.differencePieces,
    required this.counted,
    required this.countedAt,
  });

  StocktakeLine copyWith({
    int? actualQuantityPieces,
    int? differencePieces,
    bool? counted,
    DateTime? countedAt,
  }) {
    return StocktakeLine(
      itemId: itemId,
      itemNameSnapshot: itemNameSnapshot,
      itemCodeSnapshot: itemCodeSnapshot,
      unit: unit,
      itemsPerCarton: itemsPerCarton,
      systemQuantityPieces: systemQuantityPieces,
      actualQuantityPieces: actualQuantityPieces ?? this.actualQuantityPieces,
      differencePieces: differencePieces ?? this.differencePieces,
      counted: counted ?? this.counted,
      countedAt: countedAt ?? this.countedAt,
    );
  }
}
