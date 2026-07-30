/// AppRoutes manages named route definitions across the app.
class AppRoutes {
  AppRoutes._();

  static const String newMovement = '/new-movement';
  static const String newInboundMovement = '$newMovement?type=inbound';
  static const String newOutboundMovement = '$newMovement?type=outbound';
  static const String dashboard = '/';
  static const String addItem = '/add-item';
  static const String warehouseReturn = '/warehouse-return';
  static const String stockAdjustment = '/stock-adjustment';
  static const String transactionHistory = '/transaction-history';
  static const String login = '/login';
}
