import 'package:cloud_firestore/cloud_firestore.dart';

/// Translates Firestore failures into messages safe for the stocktake UI.
class StocktakeFirestoreFailureMapper {
  const StocktakeFirestoreFailureMapper._();

  static String read(FirebaseException error) => switch (error.code) {
    'permission-denied' =>
      'لا توجد صلاحية لعرض جلسة الجرد. سجّل الدخول مرة أخرى.',
    'unavailable' => 'تعذر تحميل جلسة الجرد. تحقق من الإنترنت.',
    _ => 'تعذر تحميل جلسة الجرد الآن.',
  };

  static String write(FirebaseException error) => switch (error.code) {
    'permission-denied' =>
      'تعذر حفظ جلسة الجرد بسبب الصلاحيات. سجّل الدخول مرة أخرى.',
    'unavailable' => 'تعذر حفظ جلسة الجرد. تحقق من الإنترنت.',
    'aborted' => 'تغير الرصيد أثناء الحفظ. أعد المحاولة.',
    _ => 'تعذر حفظ جلسة الجرد الآن.',
  };
}
