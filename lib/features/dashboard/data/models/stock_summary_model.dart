class StockSummaryModel {
  final int totalItemsCount;
  final int totalInboundCount;
  final int totalOutboundCount;
  final int lowStockItemsCount;

  const StockSummaryModel({
    required this.totalItemsCount,
    required this.totalInboundCount,
    required this.totalOutboundCount,
    required this.lowStockItemsCount,
  });

  factory StockSummaryModel.fromJson(Map<String, dynamic> json) =>
      StockSummaryModel(
        totalItemsCount: json['totalItemsCount'] as int? ?? 0,
        totalInboundCount: json['totalInboundCount'] as int? ?? 0,
        totalOutboundCount: json['totalOutboundCount'] as int? ?? 0,
        lowStockItemsCount: json['lowStockItemsCount'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
    'totalItemsCount': totalItemsCount,
    'totalInboundCount': totalInboundCount,
    'totalOutboundCount': totalOutboundCount,
    'lowStockItemsCount': lowStockItemsCount,
  };
}
