/// AppStrings centralizes all Arabic UI string constants for the Stock Management System.
class AppStrings {
  AppStrings._();

  // General App Info
  static const String appTitle = 'نظام إدارة المخزون';
  static const String singleWarehouseName = 'المخزن الرئيسي';
  static const String currency = 'ج.م';
  static const String email = 'البريد الإلكتروني';
  static const String emailHint = 'name@example.com';
  static const String password = 'كلمة المرور';
  static const String passwordHint = 'اكتب كلمة المرور';
  static const String signIn = 'تسجيل الدخول';
  static const String loginSubtitle = 'سجّل الدخول للوصول إلى المخزن الرئيسي';
  static const String authorizedUsersOnly = 'الدخول متاح للحسابات المعتمدة فقط';
  static const String invalidEmail = 'اكتب بريدًا إلكترونيًا صحيحًا';
  static const String passwordRequired = 'اكتب كلمة المرور';
  static const String showPassword = 'إظهار كلمة المرور';
  static const String hidePassword = 'إخفاء كلمة المرور';
  static const String logout = 'تسجيل الخروج';
  static const String logoutConfirmation = 'هل تريد تسجيل الخروج؟';
  static const String logoutFailure = 'تعذر تسجيل الخروج. حاول مرة أخرى.';

  // Navigation & Screens Titles
  static const String dashboardTitle = 'رصيد المخزن';
  static const String newMovementTitle = 'حركة جديدة';
  static const String addItemTitle = 'تعريف صنف جديد';
  static const String inboundTitle = 'تسجيل وارد جديد';
  static const String outboundTitle = 'تسجيل منصرف جديد';
  static const String warehouseReturnTitle = 'تسجيل مرتجع للمخزن';
  static const String adjustmentTitle = 'تسوية جردية لتصحيح الرصيد';
  static const String transactionHistoryTitle = 'سجل الحركات والعمليات';
  static const String printVoucherTitle = 'معاينة وطباعة الإذن';
  static const String otherOperations = 'عمليات أخرى';
  static const String warehouseReturn = 'مرتجع للمخزن';
  static const String warehouseReturnHint = 'إرجاع صنف سبق صرفه';
  static const String stocktake = 'جرد المخزن';
  static const String stocktakeHint = 'مطابقة الرصيد الفعلي';
  static const String backToNewMovement = 'الرجوع إلى الحركة الجديدة';

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
  static const String returnUiNoticeTitle = 'الحفظ متصل بالمخزون';
  static const String returnUiNoticeBody =
      'عند الحفظ سيزيد رصيد الصنف وتُسجل الحركة والمرتجع معًا، ثم ينتظر المرتجع تسوية المورد.';

  // Action Buttons
  static const String save = 'حفظ البيانات';
  static const String cancel = 'إلغاء';
  static const String printPdf = 'طباعة PDF';
  static const String searchHint = 'بحث بالاسم أو الكود أو الرقم...';
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
