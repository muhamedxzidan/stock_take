# مراجعة `lib/features` والـRefactor المنفذ

## معيار المراجعة

عدد السطور استُخدم كإشارة للبدء فقط. قرار الفصل اعتمد على:

- تعدد أسباب التغيير داخل الكلاس.
- خلط UI composition مع orchestration أو persistence.
- وجود عقدة interface تخدم مسؤوليات غير مترابطة.
- وجود تحويلات raw Firestore يمكن اختبارها بمعزل عن معاملات الكتابة.
- تجنب إنشاء طبقات أو DataSources لا تحل مشكلة فعلية.

## التدفق بعد الـRefactor

```mermaid
flowchart LR
  UI["NewMovementView"] --> Screen["NewMovementScreen"]
  Screen --> Cubit["TransactionsCubit"]
  Cubit --> Contract["TransactionsRepositoryBase"]
  Contract --> Repository["TransactionsRepository"]
  Repository --> Firestore["Firestore"]
  Firestore --> Mapper["Feature Firestore Mapper"]
  Mapper --> Model["Typed feature model"]
```

## التغييرات المنفذة

### Transactions

- `TransactionsCubit` أصبح مسؤولًا عن validation وorchestration لحفظ الوارد
  والمنصرف فقط.
- `TransactionsRepositoryBase` أصبح عقدًا صغيرًا للعمليات المستخدمة فعليًا:
  مراقبة الحركات، وحفظ الوارد والمنصرف.
- حُذف المسار التجريبي القديم غير المستخدم:
  `TransactionModel`، والسجل in-memory، وعمليات CRUD القديمة، و`AdjustmentForm`
  غير المرتبط بأي شاشة أو route.
- انتقل تحويل مستندات الحركات إلى
  `MovementRecordFirestoreMapper` مع validation صريح لقيم enum.

الأثر: انخفض `TransactionsCubit` تقريبًا من 280 إلى 111 سطرًا،
و`TransactionsRepository` من 474 إلى 326 سطرًا، مع إزالة سبب تغيير مستقل
من كل منهما.

### New movement UI

- `NewMovementScreen` يحتفظ بالـephemeral draft state، فتح dialogs/sheets،
  navigation، وبناء طلب الحفظ.
- `NewMovementView` يملك responsive layout وعرض حالة قائمة الأصناف فقط،
  ويرسل user intent عبر callbacks typed.

الأثر: انخفض ملف الشاشة من 501 إلى 259 سطرًا، وأصبحت route-level
orchestration منفصلة عن تركيب الواجهة.

### Firestore mapping

- `WarehouseReturnFirestoreMapper` يملك تحويل مستندات المرتجعات.
- `StocktakeFirestoreMapper` يملك تحويل جلسات وبنود الجرد.
- كل Mapper يرفض shape أو enum غير معروف بـ`FormatException`، لتستطيع
  الـRepository ترجمة الخطأ إلى failure آمن للمستخدم.

## كلاسات كبيرة تم الإبقاء عليها

### `StocktakeRepository`

ما زال كبيرًا لأن بدء الجرد، حفظ العدد، الاعتماد، والإلغاء معاملات Firestore
ذرّية مرتبطة بنفس aggregate وقفل المخزون. فصلها إلى DataSources أو services
سيشتت transaction invariants ويزيد dependencies من غير تغيير حقيقي في
المسؤولية. تم فقط إخراج mapping المسؤولية المستقلة.

### `StocktakeCubit`

يمتلك lifecycle واحدًا لجلسة الجرد: load، stream subscription، actions،
ومنْع stale async emissions. فصل subscription عن Cubit سيضيف callback
coordination وحالة مزدوجة من دون مستهلك مستقل.

### `ReturnsRepository` و`TransactionsRepository`

كل Repository ما زال ينسق معاملات feature واحدة، ويترجم أخطاء المصدر عند
حدود البيانات. لم تُستخرج DataSource لأن المصدر واحد ولا توجد caching أو
mapping معقدة مشتركة بين implementations.

### ملفات Widgets الكبيرة

`ReturnWorkflowCard` و`StocktakeSessionView` و`PrinterSelectionDialog`
و`ThermalReceiptContent` ملفات تجمع عدة Widgets صغيرة ذات مسؤوليات واضحة.
حجم الملف هنا لا يعني أن كلاسًا واحدًا يملك أسباب تغيير متعددة، لذلك لم
يُنفذ split شكلي.

## التحقق

- `dart format` على الملفات المتأثرة.
- `flutter analyze`: لا توجد مشاكل.
- `flutter test`: 73 اختبارًا ناجحًا.
- اختبارات جديدة لتحويلات movement/return/stocktake الصحيحة ورفض البيانات
  غير الصالحة.
- تحديث Graphify للمخرجات canonical الخاصة بـ`lib/`.
