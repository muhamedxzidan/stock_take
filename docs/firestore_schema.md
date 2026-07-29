# عقد بيانات Firestore لنظام المخزن

هذا العقد هو مصدر الحقيقة الوحيد للمخزن الواحد. أسماء الحقول الداخلية ثابتة
بالإنجليزية، والواجهة فقط هي المسؤولة عن النصوص العربية.

## مبادئ ثابتة

- لا يقرأ أو يكتب أي مستخدم قبل تسجيل الدخول بـ Email/Password.
- لا يوجد إنشاء حساب من داخل التطبيق؛ الحسابات تُنشأ يدويًا من Firebase Console.
- كل الكميات المخزنة تكون **بالقطعة**. الكراتين مجرد إدخال وعرض، وتتحول إلى قطع
  باستخدام `itemsPerCarton`.
- `createdAt` و`updatedAt` يستخدمان Server Timestamp لمنع اعتماد السجل على ساعة
  الجهاز.
- `businessAt` هو وقت العملية الذي يظهر في التقارير، بينما `createdAt` هو وقت
  الحفظ الفعلي غير القابل للتعديل.
- مستندات `movements` لا تُعدّل ولا تُحذف بعد إنشائها.
- الرصيد لا يُغيّر منفردًا: تحديث `items` وإنشاء الحركة المرتبطة يتمان داخل
  Firestore Transaction واحدة.

## المجموعات

### `items/{itemId}`

يحمل تعريف الصنف والرصيد الحالي السريع:

- `itemId` يساوي كود الصنف بعد تحويله لحروف إنجليزية كبيرة، وبذلك تمنع
  المعاملة الذرية إنشاء نفس الكود مرتين حتى مع ضغط عاملين في الوقت نفسه.
- `code`, `name`, `unit`
- `itemsPerCarton`
- `openingStockPieces`, `currentStockPieces`
- `totalInboundPieces`, `totalOutboundPieces`
- `totalCustomerReturnPieces`, `totalSupplierReturnPieces`
- `totalAdjustmentPieces`
- `active`, `lastMovementId`
- `createdAt`, `createdBy`, `updatedAt`, `updatedBy`

المعادلة المحمية بالقواعد:

```text
currentStockPieces =
  openingStockPieces
  + totalInboundPieces
  + totalCustomerReturnPieces
  - totalOutboundPieces
  - totalSupplierReturnPieces
  + totalAdjustmentPieces
```

### `movements/{movementId}`

سجل الحركة/الإذن غير القابل للتعديل:

- `voucherNumber`
- `type`: `inbound`, `outbound`, `customerReturn`, `supplierReturn`,
  `supplierReplacement`, `stocktakeAdjustment`
- `status`: دائمًا `completed` عند الحفظ
- `businessAt`, `createdAt`, `createdBy`
- `partyName`, `deliveredBy`, `receivedBy`, `driverName`, `notes`
- `itemIds`
- `itemDeltas`: خريطة `itemId → التغيير بالقطعة`
- `lines`: Snapshot للأصناف والكرتون والقطع وقت طباعة الإذن
- `returnId`, `stocktakeId`

قيمة `itemDeltas` موجبة للوارد ومرتجع العميل، وسالبة للمنصرف والرد للمورد،
وصفر عند استبدال المورد لأن البضاعة الخارجة يقابلها بديل داخل المخزن.

### `returns/{returnId}`

دورة مرتجع العميل:

1. إنشاء المرتجع بحالة `pendingSupplierResolution`.
2. إضافة الكمية إلى رصيد الصنف بحركة `customerReturn`.
3. عند وصول المورد يختار العامل:
   - `replaced`: إنشاء حركة `supplierReplacement` بصافي رصيد صفر.
   - `returnedToSupplier`: إنشاء حركة `supplierReturn` وخصم الكمية.

واجهة الإدخال وعقد المرتجع المبسطان يطلبان فقط الصنف، كوده، مصدر المرتجع،
والكمية. ويحفظ المستند كذلك `itemsPerCartonSnapshot` لعرض الكرتونة أولًا،
وحالة التسوية، المورد، حركة الاستلام، حركة التسوية، وتواريخ الإنشاء والحل.

### `stocktakes/{stocktakeId}`

جلسة جرد لها:

- `periodFrom`, `periodTo`
- `status`: `open` ثم `completed`
- `startedAt`, `completedAt`
- `completionMovementId`
- بيانات الإنشاء والإكمال

كل صنف معدود يوجد في:

`stocktakes/{stocktakeId}/lines/{itemId}`

ويحفظ `systemQuantityPieces`, `actualQuantityPieces`, `differencePieces`,
`countedAt`, و`countedBy`. عند الإكمال تُنشأ حركة `stocktakeAdjustment`
للفروق الفعلية داخل نفس المعاملة الذرية.

### `counters/{counterId}`

عدادات أرقام الأذون والمرتجعات والجرد. يسمح فقط بالبدء من 1 ثم الزيادة بمقدار
واحد داخل Transaction لمنع تكرار الأرقام.

## التسلسل الذري لأي حركة

1. إنشاء معرف الحركة مسبقًا.
2. قراءة الأصناف المطلوبة داخل Firestore Transaction.
3. تحويل الكراتين والقطع إلى إجمالي قطع وحساب الرصيد الجديد.
4. رفض المنصرف أو الرد للمورد إذا أصبح الرصيد سالبًا.
5. إنشاء `movements/{movementId}` مع `itemDeltas`.
6. تحديث كل صنف مع `lastMovementId` والإجماليات المرتبطة بنوع الحركة.
7. عند المرتجع أو الجرد، إنشاء/تحديث المستند المرتبط في نفس Transaction.
8. بعد نجاح المعاملة فقط تُطبع الفاتورة وتُفرغ قائمة الإذن الحالي.

## التقارير

- اليومي أو من/إلى: `movements` بمدى `businessAt`.
- حسب نوع الحركة: `type + businessAt`.
- تاريخ صنف: `itemIds array-contains + businessAt`.
- المرتجعات المعلقة: `returns status + receivedAt`.
- تاريخ مرتجعات صنف: `returns itemId + receivedAt`.
- جلسات الجرد: `stocktakes status + startedAt`.

الفهارس المطلوبة موجودة في `firestore.indexes.json`.

## حدود الأمان الحالية

القواعد تثق فقط في حسابات Firebase Authentication التي ينشئها صاحب المشروع
يدويًا، وتمنع غير المسجلين والحذف وتغيير السجل القديم والرصيد السالب والحقول
غير المعروفة. لا توجد أدوار متعددة في هذه المرحلة لأن النظام مخزن واحد
وبصلاحية تشغيل واحدة.
