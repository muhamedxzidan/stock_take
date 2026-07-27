/// ItemModel represents an inventory item with calculated stock balance (Inbound - Outbound).
class ItemModel {
  final String id;
  final String code;
  final String name;
  final String unit; // e.g. 'قطعة', 'كرتونة'
  final int itemsPerCarton;
  final int openingBalance;
  final int totalInbound;
  final int totalOutbound;

  const ItemModel({
    required this.id,
    required this.code,
    required this.name,
    required this.unit,
    required this.itemsPerCarton,
    required this.openingBalance,
    required this.totalInbound,
    required this.totalOutbound,
  });

  /// Automatically calculated stock balance: (Opening + Inbound - Outbound)
  int get currentStockBalance => openingBalance + totalInbound - totalOutbound;

  /// Stock expressed in cartons and leftover pieces
  String get formattedCartonStock {
    if (itemsPerCarton <= 0) return '$currentStockBalance $unit';
    final cartons = currentStockBalance ~/ itemsPerCarton;
    final pieces = currentStockBalance % itemsPerCarton;
    return '$cartons كرتونة ($pieces قطعة)';
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        id: json['id'] as String? ?? '',
        code: json['code'] as String? ?? '',
        name: json['name'] as String? ?? '',
        unit: json['unit'] as String? ?? 'قطعة',
        itemsPerCarton: json['itemsPerCarton'] as int? ?? 1,
        openingBalance: json['openingBalance'] as int? ?? 0,
        totalInbound: json['totalInbound'] as int? ?? 0,
        totalOutbound: json['totalOutbound'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'unit': unit,
        'itemsPerCarton': itemsPerCarton,
        'openingBalance': openingBalance,
        'totalInbound': totalInbound,
        'totalOutbound': totalOutbound,
      };

  ItemModel copyWith({
    String? id,
    String? code,
    String? name,
    String? unit,
    int? itemsPerCarton,
    int? openingBalance,
    int? totalInbound,
    int? totalOutbound,
  }) {
    return ItemModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      itemsPerCarton: itemsPerCarton ?? this.itemsPerCarton,
      openingBalance: openingBalance ?? this.openingBalance,
      totalInbound: totalInbound ?? this.totalInbound,
      totalOutbound: totalOutbound ?? this.totalOutbound,
    );
  }
}
