import '../../../../core/models/inventory_item.dart';

enum MovementKind {
  inbound,
  outbound;

  String get label => this == MovementKind.inbound ? 'وارد' : 'منصرف';

  String get voucherLabel =>
      this == MovementKind.inbound ? 'الوارد' : 'المنصرف';

  String get actionLabel =>
      this == MovementKind.inbound ? 'إضافة للمخزن' : 'خصم من المخزن';
}

class QuantitySelection {
  final int cartons;
  final int pieces;

  const QuantitySelection({required this.cartons, required this.pieces});

  int totalPiecesFor(InventoryItem item) =>
      (cartons * item.itemsPerCarton) + pieces;
}

class MovementLineViewData {
  final InventoryItem item;
  final int cartons;
  final int pieces;

  const MovementLineViewData({
    required this.item,
    required this.cartons,
    required this.pieces,
  });

  int get totalPieces => (cartons * item.itemsPerCarton) + pieces;

  String get quantityLabel {
    final parts = <String>[
      if (cartons > 0) '$cartons كرتونة',
      if (pieces > 0) '$pieces قطعة',
    ];
    return parts.join(' + ');
  }
}

class MovementVoucherDetails {
  final String partyName;
  final String deliveredBy;
  final String receivedBy;
  final String driverName;
  final String date;
  final String notes;

  const MovementVoucherDetails({
    required this.partyName,
    required this.deliveredBy,
    required this.receivedBy,
    required this.driverName,
    required this.date,
    required this.notes,
  });
}
