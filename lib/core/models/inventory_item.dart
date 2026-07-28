class InventoryItem {
  final String id;
  final String code;
  final String name;
  final String unit;
  final int itemsPerCarton;
  final int openingStockPieces;
  final int currentStockPieces;
  final int totalInboundPieces;
  final int totalOutboundPieces;
  final int totalCustomerReturnPieces;
  final int totalSupplierReturnPieces;
  final int totalAdjustmentPieces;
  final bool active;

  const InventoryItem({
    required this.id,
    required this.code,
    required this.name,
    required this.unit,
    required this.itemsPerCarton,
    required this.openingStockPieces,
    required this.currentStockPieces,
    required this.totalInboundPieces,
    required this.totalOutboundPieces,
    required this.totalCustomerReturnPieces,
    required this.totalSupplierReturnPieces,
    required this.totalAdjustmentPieces,
    required this.active,
  });

  int get currentStockBalance => currentStockPieces;

  String get formattedCartonStock {
    final cartons = currentStockPieces ~/ itemsPerCarton;
    final pieces = currentStockPieces % itemsPerCarton;
    return '$cartons كرتونة ($pieces قطعة)';
  }

  factory InventoryItem.fromMap({
    required String id,
    required Map<String, dynamic> data,
  }) {
    final code = data['code'];
    final name = data['name'];
    final unit = data['unit'];
    final itemsPerCarton = data['itemsPerCarton'];
    final openingStockPieces = data['openingStockPieces'];
    final currentStockPieces = data['currentStockPieces'];
    final totalInboundPieces = data['totalInboundPieces'];
    final totalOutboundPieces = data['totalOutboundPieces'];
    final totalCustomerReturnPieces = data['totalCustomerReturnPieces'];
    final totalSupplierReturnPieces = data['totalSupplierReturnPieces'];
    final totalAdjustmentPieces = data['totalAdjustmentPieces'];
    final active = data['active'];

    if (code is! String ||
        name is! String ||
        unit is! String ||
        itemsPerCarton is! int ||
        openingStockPieces is! int ||
        currentStockPieces is! int ||
        totalInboundPieces is! int ||
        totalOutboundPieces is! int ||
        totalCustomerReturnPieces is! int ||
        totalSupplierReturnPieces is! int ||
        totalAdjustmentPieces is! int ||
        active is! bool) {
      throw const FormatException('Malformed inventory item data.');
    }

    return InventoryItem(
      id: id,
      code: code,
      name: name,
      unit: unit,
      itemsPerCarton: itemsPerCarton,
      openingStockPieces: openingStockPieces,
      currentStockPieces: currentStockPieces,
      totalInboundPieces: totalInboundPieces,
      totalOutboundPieces: totalOutboundPieces,
      totalCustomerReturnPieces: totalCustomerReturnPieces,
      totalSupplierReturnPieces: totalSupplierReturnPieces,
      totalAdjustmentPieces: totalAdjustmentPieces,
      active: active,
    );
  }

  Map<String, Object> toCreateMap() {
    return {
      'code': code,
      'name': name,
      'unit': unit,
      'itemsPerCarton': itemsPerCarton,
      'openingStockPieces': openingStockPieces,
      'currentStockPieces': currentStockPieces,
      'totalInboundPieces': totalInboundPieces,
      'totalOutboundPieces': totalOutboundPieces,
      'totalCustomerReturnPieces': totalCustomerReturnPieces,
      'totalSupplierReturnPieces': totalSupplierReturnPieces,
      'totalAdjustmentPieces': totalAdjustmentPieces,
      'active': active,
      'lastMovementId': '',
    };
  }

  InventoryItem copyWith({
    String? id,
    String? code,
    String? name,
    String? unit,
    int? itemsPerCarton,
    int? openingStockPieces,
    int? currentStockPieces,
    int? totalInboundPieces,
    int? totalOutboundPieces,
    int? totalCustomerReturnPieces,
    int? totalSupplierReturnPieces,
    int? totalAdjustmentPieces,
    bool? active,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      itemsPerCarton: itemsPerCarton ?? this.itemsPerCarton,
      openingStockPieces: openingStockPieces ?? this.openingStockPieces,
      currentStockPieces: currentStockPieces ?? this.currentStockPieces,
      totalInboundPieces: totalInboundPieces ?? this.totalInboundPieces,
      totalOutboundPieces: totalOutboundPieces ?? this.totalOutboundPieces,
      totalCustomerReturnPieces:
          totalCustomerReturnPieces ?? this.totalCustomerReturnPieces,
      totalSupplierReturnPieces:
          totalSupplierReturnPieces ?? this.totalSupplierReturnPieces,
      totalAdjustmentPieces:
          totalAdjustmentPieces ?? this.totalAdjustmentPieces,
      active: active ?? this.active,
    );
  }
}
