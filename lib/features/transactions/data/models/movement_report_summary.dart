import 'movement_record.dart';

class MovementReportSummary {
  final int movementCount;
  final int inboundPieces;
  final int outboundPieces;
  final int customerReturnPieces;
  final int supplierReturnPieces;
  final int supplierReplacementCount;
  final int stocktakeAdjustmentNetPieces;

  const MovementReportSummary({
    required this.movementCount,
    required this.inboundPieces,
    required this.outboundPieces,
    required this.customerReturnPieces,
    required this.supplierReturnPieces,
    required this.supplierReplacementCount,
    required this.stocktakeAdjustmentNetPieces,
  });

  factory MovementReportSummary.fromMovements(List<MovementRecord> movements) {
    var inboundPieces = 0;
    var outboundPieces = 0;
    var customerReturnPieces = 0;
    var supplierReturnPieces = 0;
    var supplierReplacementCount = 0;
    var stocktakeAdjustmentNetPieces = 0;

    for (final movement in movements) {
      switch (movement.type) {
        case MovementRecordType.inbound:
          inboundPieces += movement.netStockPieces;
        case MovementRecordType.outbound:
          outboundPieces += movement.netStockPieces.abs();
        case MovementRecordType.customerReturn:
          customerReturnPieces += movement.netStockPieces;
        case MovementRecordType.supplierReturn:
          supplierReturnPieces += movement.netStockPieces.abs();
        case MovementRecordType.supplierReplacement:
          supplierReplacementCount += 1;
        case MovementRecordType.stocktakeAdjustment:
          stocktakeAdjustmentNetPieces += movement.netStockPieces;
      }
    }

    return MovementReportSummary(
      movementCount: movements.length,
      inboundPieces: inboundPieces,
      outboundPieces: outboundPieces,
      customerReturnPieces: customerReturnPieces,
      supplierReturnPieces: supplierReturnPieces,
      supplierReplacementCount: supplierReplacementCount,
      stocktakeAdjustmentNetPieces: stocktakeAdjustmentNetPieces,
    );
  }
}
