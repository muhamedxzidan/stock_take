/// AppStrings centralizes all Arabic UI string constants for the Stock Management System.
class AppStrings {
  AppStrings._();

  // General App Info
  static const String appTitle = 'نظام إدارة المخزون';
  static const String singleWarehouseName = 'المخزن الرئيسي';
  static const String currency = 'ج.م';

  // Navigation & Screens Titles
  static const String dashboardTitle = 'الرئيسية ورصيد المخزون';
  static const String addItemTitle = 'تعريف صنف جديد';
  static const String inboundTitle = 'تسجيل وارد جديد';
  static const String outboundTitle = 'تسجيل منصرف جديد';
  static const String warehouseReturnTitle = 'تسجيل مرتجع للمخزن';
  static const String adjustmentTitle = 'تسوية جردية لتصحيح الرصيد';
  static const String transactionHistoryTitle = 'سجل الحركات والعمليات';
  static const String printVoucherTitle = 'معاينة وطباعة الإذن';

  // Item Fields
  static const String itemName = 'اسم الصنف';
  static const String itemCode = 'كود الصنف';
  static const String itemUnit = 'الوحدة';
  static const String itemsPerCarton = 'عدد القطع في الكرتونة';
  static const String initialBalance = 'الرصيد الافتتاحي';
  static const String currentBalance = 'الرصيد الحالي';
  static const String totalInbound = 'إجمالي الوارد';
  static const String totalOutbound = 'إجمالي المنصرف';
  static const String piecesCount = 'قطع';
  static const String cartonCount = 'كرتونة';

  // Form Fields & Labels
  static const String supplierName = 'اسم المورد';
  static const String recipientEntity = 'الجهة المستلمة';
  static const String deliveredBy = 'اسم من سلّم';
  static const String receivedBy = 'اسم من استلم';
  static const String dispatchedBy = 'اسم من صرف';
  static const String driverName = 'اسم السائق';
  static const String transactionDate = 'تاريخ العملية';
  static const String quantityPieces = 'الكمية (بالقطعة)';
  static const String quantityCartons = 'الكمية (بالكرتونة)';
  static const String adjustmentReason = 'سبب التسوية الجردية';
  static const String actualCount = 'العدد الفعلي بالجرد';
  static const String systemCount = 'العدد المكتبي بالنظام';
  static const String diffCount = 'الفارق (+ / -)';
  static const String notes = 'ملاحظات إضافية';

  // Warehouse Return Fields
  static const String originalVoucherNumber = 'رقم إذن الصرف الأصلي';
  static const String returnSource = 'الجهة المُرجعة';
  static const String returnedBy = 'اسم من سلّم المرتجع';
  static const String returnReason = 'سبب المرتجع';
  static const String returnCondition = 'حالة الصنف المرتجع';
  static const String returnQuantity = 'الكمية المرتجعة';
  static const String returnUiNoticeTitle = 'واجهة تجريبية جاهزة للربط';
  static const String returnUiNoticeBody =
      'لن يتم تعديل رصيد المخزون أو حفظ أي بيانات في هذه المرحلة.';
  static const String returnUiOnlyMessage =
      'تم تجهيز نموذج المرتجع كواجهة فقط، وسيتم ربط الحفظ لاحقًا.';

  // Action Buttons
  static const String save = 'حفظ البيانات';
  static const String cancel = 'إلغاء';
  static const String printPdf = 'طباعة PDF';
  static const String searchHint = 'بحث بكود أو اسم الصنف...';
  static const String filterAll = 'الكل';
  static const String filterInbound = 'وارد';
  static const String filterOutbound = 'منصرف';
  static const String filterAdjustment = 'تسوية';

  // Messages & Status
  static const String lowStockWarning = 'مخزون منخفض';
  static const String inStock = 'متوفر بالمخزن';
  static const String outOfStock = 'نفد المخزون';
  static const String successSave = 'تم حفظ البيانات بنجاح';
  static const String emptyList = 'لا توجد بيانات للعرض حالياً';
}
