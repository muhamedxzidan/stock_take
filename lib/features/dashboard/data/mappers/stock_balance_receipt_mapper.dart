import '../../../../core/models/carton_piece_quantity.dart';
import '../../../../core/models/inventory_item.dart';
import '../../../../core/models/thermal_receipt_data.dart';

class StockBalanceReceiptMapper {
  const StockBalanceReceiptMapper._();

  static ThermalReceiptData fromItems({
    required List<InventoryItem> items,
    required DateTime generatedAt,
  }) {
    return ThermalReceiptData(
      documentTitle: 'كشف رصيد المخزن',
      voucherNumber: _buildReference(generatedAt),
      movementLabel: 'الرصيد الحالي لكل الأصناف',
      date: _formatDateTime(generatedAt),
      partyLabel: '',
      partyName: '',
      deliveredBy: '',
      receivedBy: '',
      driverName: '',
      notes: 'عدد الأصناف: ${items.length}',
      lines: items
          .map((item) {
            final quantity = CartonPieceQuantity.fromTotalPieces(
              totalPieces: item.currentStockPieces,
              itemsPerCarton: item.itemsPerCarton,
            );
            return ThermalReceiptLine(
              itemName: item.name,
              itemCode: item.code,
              cartons: quantity.cartons,
              loosePieces: quantity.pieces,
              totalPieces: item.currentStockPieces,
            );
          })
          .toList(growable: false),
    );
  }

  static String _buildReference(DateTime dateTime) {
    return 'STOCK-${dateTime.year}'
        '${_twoDigits(dateTime.month)}'
        '${_twoDigits(dateTime.day)}-'
        '${_twoDigits(dateTime.hour)}'
        '${_twoDigits(dateTime.minute)}';
  }

  static String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${_twoDigits(dateTime.month)}-'
        '${_twoDigits(dateTime.day)} '
        '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}';
  }

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');
}
