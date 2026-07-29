import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/core/models/thermal_receipt_data.dart';
import 'package:stock_take/features/printing/presentation/widgets/thermal_receipt_content.dart';

void main() {
  testWidgets('renders Arabic receipt content inside the 576-dot width', (
    tester,
  ) async {
    const receipt = ThermalReceiptData(
      voucherNumber: 'IN-2026-000001',
      movementLabel: 'إذن وارد',
      date: '2026-07-29',
      partyLabel: 'المورد',
      partyName: 'المورد الرئيسي',
      deliveredBy: 'أحمد',
      receivedBy: 'محمد',
      driverName: '',
      notes: 'اختبار',
      lines: [
        ThermalReceiptLine(
          itemName: 'مياه معدنية',
          itemCode: 'S-N-123456',
          cartons: 2,
          loosePieces: 3,
          totalPieces: 27,
        ),
      ],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: SingleChildScrollView(
          child: SizedBox(
            width: 576,
            child: ThermalReceiptContent(receipt: receipt),
          ),
        ),
      ),
    );

    expect(find.text('إذن حركة مخزن'), findsOneWidget);
    expect(find.text('IN-2026-000001'), findsOneWidget);
    expect(find.textContaining('2 كرتونة'), findsOneWidget);
    expect(find.textContaining('3 قطعة مفردة'), findsOneWidget);
    expect(find.text('27 قطعة'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
