import '../../../../core/extensions/inventory_number_parsing.dart';

enum MovementRecordType {
  inbound,
  outbound,
  customerReturn,
  supplierReturn,
  supplierReplacement,
  stocktakeAdjustment,
}

class MovementRecordLine {
  final String itemId;
  final String itemCode;
  final String itemName;
  final String unit;
  final int itemsPerCarton;
  final int cartons;
  final int pieces;
  final int totalPieces;

  const MovementRecordLine({
    required this.itemId,
    required this.itemCode,
    required this.itemName,
    required this.unit,
    required this.itemsPerCarton,
    required this.cartons,
    required this.pieces,
    required this.totalPieces,
  });

  bool matchesSearch(String normalizedQuery) {
    if (itemName.toLowerCase().contains(normalizedQuery) ||
        itemCode.toLowerCase().contains(normalizedQuery)) {
      return true;
    }

    final searchedNumber = int.tryParse(normalizedQuery);
    final codeNumberMatch = RegExp(r'(\d+)$').firstMatch(itemCode);
    final codeNumber = codeNumberMatch == null
        ? null
        : int.tryParse(codeNumberMatch.group(1)!);
    return searchedNumber != null && searchedNumber == codeNumber;
  }
}

class MovementRecord {
  final String id;
  final String voucherNumber;
  final MovementRecordType type;
  final DateTime businessAt;
  final String partyName;
  final String deliveredBy;
  final String receivedBy;
  final String driverName;
  final String notes;
  final List<MovementRecordLine> lines;
  final Map<String, int> itemDeltas;

  const MovementRecord({
    required this.id,
    required this.voucherNumber,
    required this.type,
    required this.businessAt,
    required this.partyName,
    required this.deliveredBy,
    required this.receivedBy,
    required this.driverName,
    required this.notes,
    required this.lines,
    required this.itemDeltas,
  });

  int get netStockPieces =>
      itemDeltas.values.fold(0, (sum, delta) => sum + delta);

  int get affectedPieces =>
      itemDeltas.values.fold(0, (sum, delta) => sum + delta.abs());

  bool matchesSearch(String query) {
    final normalizedQuery = query
        .trim()
        .normalizedInventoryDigits
        .toLowerCase();
    if (normalizedQuery.isEmpty) {
      return true;
    }

    return voucherNumber.toLowerCase().contains(normalizedQuery) ||
        partyName.toLowerCase().contains(normalizedQuery) ||
        deliveredBy.toLowerCase().contains(normalizedQuery) ||
        receivedBy.toLowerCase().contains(normalizedQuery) ||
        driverName.toLowerCase().contains(normalizedQuery) ||
        lines.any((line) => line.matchesSearch(normalizedQuery));
  }
}
