class ThermalReceiptLine {
  final String itemName;
  final String itemCode;
  final int cartons;
  final int loosePieces;
  final int totalPieces;

  const ThermalReceiptLine({
    required this.itemName,
    required this.itemCode,
    required this.cartons,
    required this.loosePieces,
    required this.totalPieces,
  });
}

class ThermalReceiptData {
  final String voucherNumber;
  final String movementLabel;
  final String date;
  final String partyLabel;
  final String partyName;
  final String deliveredBy;
  final String receivedBy;
  final String driverName;
  final String notes;
  final List<ThermalReceiptLine> lines;

  const ThermalReceiptData({
    required this.voucherNumber,
    required this.movementLabel,
    required this.date,
    required this.partyLabel,
    required this.partyName,
    required this.deliveredBy,
    required this.receivedBy,
    required this.driverName,
    required this.notes,
    required this.lines,
  });

  int get totalCartons => lines.fold(0, (total, line) => total + line.cartons);

  int get totalPieces =>
      lines.fold(0, (total, line) => total + line.totalPieces);
}
