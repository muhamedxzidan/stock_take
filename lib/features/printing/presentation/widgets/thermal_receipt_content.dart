import 'package:flutter/material.dart';

import '../../../../core/models/thermal_receipt_data.dart';

class ThermalReceiptContent extends StatelessWidget {
  final ThermalReceiptData receipt;

  const ThermalReceiptContent({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ColoredBox(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  'assets/branding/el_saudi_receipt_mono.png',
                  key: const Key('receipt-brand-logo'),
                  width: 420,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                  semanticLabel: 'شعار EL SAUDI',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                receipt.documentTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                receipt.movementLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                receipt.voucherNumber,
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const _ReceiptDivider(),
              _ReceiptDetail(label: 'التاريخ', value: receipt.date),
              if (receipt.partyName.trim().isNotEmpty)
                _ReceiptDetail(
                  label: receipt.partyLabel,
                  value: receipt.partyName,
                ),
              if (receipt.deliveredBy.trim().isNotEmpty)
                _ReceiptDetail(label: 'من سلّم', value: receipt.deliveredBy),
              if (receipt.receivedBy.trim().isNotEmpty)
                _ReceiptDetail(label: 'من استلم', value: receipt.receivedBy),
              if (receipt.driverName.trim().isNotEmpty)
                _ReceiptDetail(label: 'السائق', value: receipt.driverName),
              const _ReceiptDivider(),
              const Text(
                'الأصناف',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              ...receipt.lines.indexed.map(
                (indexedLine) => _ReceiptItem(
                  index: indexedLine.$1 + 1,
                  line: indexedLine.$2,
                ),
              ),
              const _ReceiptDivider(),
              const Text(
                'الإجمالي',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              _ReceiptTotal(
                label: 'إجمالي الكراتين',
                value: '${receipt.totalCartons} كرتونة',
              ),
              const SizedBox(height: 5),
              _ReceiptTotal(
                label: 'إجمالي القطع',
                value: '${receipt.totalPieces} قطعة',
              ),
              if (receipt.notes.trim().isNotEmpty) ...[
                const _ReceiptDivider(),
                _ReceiptDetail(label: 'ملاحظات', value: receipt.notes),
              ],
              const SizedBox(height: 24),
              const Text(
                'تمت الطباعة من نظام المخزن',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReceiptItem extends StatelessWidget {
  final int index;
  final ThermalReceiptLine line;

  const _ReceiptItem({required this.index, required this.line});

  @override
  Widget build(BuildContext context) {
    final quantities = <String>[
      if (line.cartons > 0) '${line.cartons} كرتونة',
      if (line.loosePieces > 0) '${line.loosePieces} قطعة مفردة',
    ];
    final quantityLabel = quantities.isEmpty
        ? '0 قطعة'
        : quantities.join(' + ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '$index. ${line.itemName}',
            style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          Text(
            'الكود: ${line.itemCode}',
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'الكمية: $quantityLabel',
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'إجمالي الصنف: ${line.totalPieces} قطعة',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Divider(height: 2, thickness: 2, color: Colors.black),
        ],
      ),
    );
  }
}

class _ReceiptTotal extends StatelessWidget {
  final String label;
  final String value;

  const _ReceiptTotal({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
          ),
        ),
        Text(
          value,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _ReceiptDetail extends StatelessWidget {
  final String label;
  final String value;

  const _ReceiptDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            TextSpan(text: value),
          ],
        ),
        style: const TextStyle(fontSize: 24, height: 1.25),
      ),
    );
  }
}

class _ReceiptDivider extends StatelessWidget {
  const _ReceiptDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 2, thickness: 2, color: Colors.black),
    );
  }
}
