import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/core/models/thermal_receipt_data.dart';
import 'package:stock_take/features/printing/presentation/widgets/thermal_receipt_content.dart';

void main() {
  testWidgets('renders Arabic receipt content inside the 576-dot width', (
    tester,
  ) async {
    const receipt = ThermalReceiptData(
      documentTitle: 'إذن حركة مخزن',
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
        ThermalReceiptLine(
          itemName: 'مناديل ورقية',
          itemCode: 'S-N-654321',
          cartons: 3,
          loosePieces: 0,
          totalPieces: 36,
        ),
        ThermalReceiptLine(
          itemName: 'صنف رصيده صفر',
          itemCode: 'S-N-000000',
          cartons: 0,
          loosePieces: 0,
          totalPieces: 0,
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
    expect(find.byKey(const Key('receipt-brand-logo')), findsOneWidget);
    expect(find.text('الكمية: 2 كرتونة + 3 قطعة مفردة'), findsOneWidget);
    expect(find.text('الكمية: 0 قطعة'), findsOneWidget);
    expect(find.text('إجمالي الكراتين'), findsOneWidget);
    expect(find.text('5 كرتونة'), findsOneWidget);
    expect(find.text('إجمالي القطع'), findsOneWidget);
    expect(find.text('63 قطعة'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
