import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/core/models/inventory_item.dart';
import 'package:stock_take/features/transactions/data/models/inventory_movement.dart';
import 'package:stock_take/features/transactions/presentation/widgets/movement_ui_types.dart';
import 'package:stock_take/features/transactions/presentation/widgets/movement_voucher_preview_dialog.dart';

void main() {
  for (final movementKind in MovementKind.values) {
    testWidgets(
      'shows the full item code as read-only text in ${movementKind.name} voucher',
      (tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            builder: (context, child) => MaterialApp(
              home: Scaffold(
                body: MovementVoucherPreviewDialog(
                  movementKind: movementKind,
                  lines: const [
                    MovementLineViewData(
                      item: InventoryItem(
                        id: 'S-N-12',
                        code: 'S-N-12',
                        name: 'مياه معدنية',
                        unit: 'piece',
                        itemsPerCarton: 24,
                        openingStockPieces: 48,
                        currentStockPieces: 48,
                        totalInboundPieces: 0,
                        totalOutboundPieces: 0,
                        totalCustomerReturnPieces: 0,
                        totalSupplierReturnPieces: 0,
                        totalAdjustmentPieces: 0,
                        active: true,
                      ),
                      cartons: 1,
                      pieces: 2,
                    ),
                  ],
                  details: const MovementVoucherDetails(
                    partyName: 'جهة اختبار',
                    deliveredBy: '',
                    receivedBy: '',
                    driverName: '',
                    date: '2026-07-28',
                    notes: '',
                  ),
                  movementDraft: InventoryMovementDraft(
                    lines: const [
                      InventoryMovementLine(
                        itemId: 'S-N-12',
                        itemCode: 'S-N-12',
                        itemName: 'مياه معدنية',
                        unit: 'piece',
                        itemsPerCarton: 24,
                        cartons: 1,
                        pieces: 2,
                      ),
                    ],
                    partyName: 'جهة اختبار',
                    deliveredBy: '',
                    receivedBy: '',
                    driverName: '',
                    notes: '',
                    businessDate: DateTime(2026, 7, 28),
                  ),
                ),
              ),
            ),
          ),
        );

        expect(
          find.byKey(const Key('voucher-item-code-S-N-12')),
          findsOneWidget,
        );
        expect(find.text('S-N-12'), findsOneWidget);
        expect(find.widgetWithText(TextField, 'S-N-12'), findsNothing);
      },
    );
  }
}
