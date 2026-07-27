import '../models/transaction_model.dart';
import 'transactions_repository_base.dart';

class TransactionsRepository implements TransactionsRepositoryBase {
  final List<TransactionModel> _logs = [
    const TransactionModel(
      id: '101',
      voucherNumber: 'INV-2026-001',
      type: TransactionType.inbound,
      itemId: '1',
      itemName: 'شامبو لوريال 400 مل',
      itemCode: 'ITM-001',
      quantity: 50,
      unit: 'قطعة',
      partyName: 'شركة النيل للتوريدات',
      actorName: 'أحمد محمود (مندوب المورد)',
      receiverName: 'محمد زيدان (أمين المخزن)',
      date: '2026-07-24 10:30 ص',
      notes: 'توريد دفعة شهر يوليو',
    ),
    const TransactionModel(
      id: '102',
      voucherNumber: 'OUT-2026-001',
      type: TransactionType.outbound,
      itemId: '2',
      itemName: 'صابون دوف زهر 100جم',
      itemCode: 'ITM-002',
      quantity: 30,
      unit: 'قطعة',
      partyName: 'فرع الجيزة الرئيسي',
      actorName: 'محمد زيدان (أمين المخزن)',
      receiverName: 'محمود حسن (سائق النقل)',
      date: '2026-07-24 02:15 م',
      notes: 'صرف بضاعة لفرع الجيزة',
    ),
    const TransactionModel(
      id: '103',
      voucherNumber: 'ADJ-2026-001',
      type: TransactionType.adjustment,
      itemId: '3',
      itemName: 'معجون أسنان سنسوداين 75مل',
      itemCode: 'ITM-003',
      quantity: -5,
      unit: 'قطعة',
      partyName: 'تعديل جرد دوري',
      actorName: 'محمد زيدان',
      receiverName: 'محمد زيدان',
      date: '2026-07-25 09:00 ص',
      notes: 'عجز جردي نتيجة تالف بضاعة',
    ),
  ];

  @override
  Future<void> createTransaction(TransactionModel transaction) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logs.insert(0, transaction);
  }

  @override
  Future<List<TransactionModel>> fetchTransactions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_logs);
  }
}
