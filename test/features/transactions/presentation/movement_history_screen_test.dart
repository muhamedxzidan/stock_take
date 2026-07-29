import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/transactions/cubit/movement_history_cubit.dart';
import 'package:stock_take/features/printing/cubit/printer_cubit.dart';
import 'package:stock_take/features/transactions/data/models/movement_record.dart';
import 'package:stock_take/features/transactions/presentation/screens/transaction_history_screen.dart';

import '../../../support/fake_transactions_repository.dart';
import '../../../support/fake_printer_repository.dart';

void main() {
  testWidgets('shows unified movement totals and filters the live source', (
    tester,
  ) async {
    final repository = FakeTransactionsRepository(
      movements: [
        _movement(
          id: 'in',
          voucher: 'IN-2026-000001',
          type: MovementRecordType.inbound,
          delta: 12,
        ),
        _movement(
          id: 'out',
          voucher: 'OUT-2026-000001',
          type: MovementRecordType.outbound,
          delta: -5,
        ),
      ],
    );
    final cubit = MovementHistoryCubit(repository);
    final printerRepository = FakePrinterRepository();
    final printerCubit = PrinterCubit(printerRepository)..initialize();
    addTearDown(() async {
      await cubit.close();
      await printerCubit.close();
      await printerRepository.close();
      await repository.close();
    });

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: cubit),
            BlocProvider.value(value: printerCubit),
          ],
          child: const MaterialApp(home: TransactionHistoryScreen()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('الحركات: 2 حركة'), findsOneWidget);
    expect(find.text('الوارد: 12 قطعة'), findsOneWidget);
    expect(find.text('المنصرف: 5 قطعة'), findsOneWidget);
    expect(find.byKey(const Key('movement-record-in')), findsOneWidget);
    expect(find.byKey(const Key('movement-record-out')), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'منصرف'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byKey(const Key('movement-record-in')), findsNothing);
    expect(find.byKey(const Key('movement-record-out')), findsOneWidget);
    expect(find.text('الحركات: 1 حركة'), findsOneWidget);

    await tester.tap(find.byKey(const Key('movement-record-out')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('print-movement-out')), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}

MovementRecord _movement({
  required String id,
  required String voucher,
  required MovementRecordType type,
  required int delta,
}) {
  return MovementRecord(
    id: id,
    voucherNumber: voucher,
    type: type,
    businessAt: DateTime(2026, 7, 28),
    partyName: 'جهة اختبار',
    deliveredBy: 'مسؤول',
    receivedBy: 'أمين المخزن',
    driverName: '',
    notes: '',
    lines: [
      MovementRecordLine(
        itemId: 'S-N-1',
        itemCode: 'S-N-1',
        itemName: 'صنف اختبار',
        unit: 'piece',
        itemsPerCarton: 12,
        cartons: 0,
        pieces: delta.abs(),
        totalPieces: delta.abs(),
      ),
    ],
    itemDeltas: {'S-N-1': delta},
  );
}
