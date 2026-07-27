enum TransactionType { inbound, outbound, adjustment }

/// TransactionModel records inbound, outbound, and stock adjustment logs.
class TransactionModel {
  final String id;
  final String voucherNumber;
  final TransactionType type;
  final String itemId;
  final String itemName;
  final String itemCode;
  final int quantity;
  final String unit;
  final String partyName; // Supplier or Recipient Entity
  final String actorName; // Delivered by (for inbound) / Dispatched by (for outbound)
  final String receiverName; // Received by
  final String date;
  final String notes;

  const TransactionModel({
    required this.id,
    required this.voucherNumber,
    required this.type,
    required this.itemId,
    required this.itemName,
    required this.itemCode,
    required this.quantity,
    required this.unit,
    required this.partyName,
    required this.actorName,
    required this.receiverName,
    required this.date,
    required this.notes,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        id: json['id'] as String? ?? '',
        voucherNumber: json['voucherNumber'] as String? ?? '',
        type: TransactionType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => TransactionType.inbound,
        ),
        itemId: json['itemId'] as String? ?? '',
        itemName: json['itemName'] as String? ?? '',
        itemCode: json['itemCode'] as String? ?? '',
        quantity: json['quantity'] as int? ?? 0,
        unit: json['unit'] as String? ?? 'قطعة',
        partyName: json['partyName'] as String? ?? '',
        actorName: json['actorName'] as String? ?? '',
        receiverName: json['receiverName'] as String? ?? '',
        date: json['date'] as String? ?? '',
        notes: json['notes'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'voucherNumber': voucherNumber,
        'type': type.name,
        'itemId': itemId,
        'itemName': itemName,
        'itemCode': itemCode,
        'quantity': quantity,
        'unit': unit,
        'partyName': partyName,
        'actorName': actorName,
        'receiverName': receiverName,
        'date': date,
        'notes': notes,
      };
}
