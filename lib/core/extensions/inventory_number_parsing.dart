extension InventoryNumberParsing on String {
  String get normalizedInventoryDigits {
    const arabicIndicDigits = '٠١٢٣٤٥٦٧٨٩';
    const easternArabicDigits = '۰۱۲۳۴۵۶۷۸۹';
    var normalized = this;

    for (var index = 0; index <= 9; index++) {
      normalized = normalized
          .replaceAll(arabicIndicDigits[index], '$index')
          .replaceAll(easternArabicDigits[index], '$index');
    }

    return normalized;
  }

  int? toInventoryInteger() => int.tryParse(trim().normalizedInventoryDigits);
}
