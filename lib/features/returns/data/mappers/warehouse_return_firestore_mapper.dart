import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/warehouse_return_record.dart';

/// Validates and maps Firestore return documents into feature models.
class WarehouseReturnFirestoreMapper {
  const WarehouseReturnFirestoreMapper._();

  static WarehouseReturnRecord fromMap({
    required String id,
    required Map<String, dynamic> data,
  }) {
    final returnNumber = data['returnNumber'];
    final itemId = data['itemId'];
    final itemName = data['itemNameSnapshot'];
    final itemCode = data['itemCodeSnapshot'];
    final itemsPerCarton = data['itemsPerCartonSnapshot'];
    final quantityPieces = data['quantityPieces'];
    final sourceName = data['sourceName'];
    final status = data['status'];
    final receivedAt = data['receivedAt'];

    if (returnNumber is! String ||
        itemId is! String ||
        itemName is! String ||
        itemCode is! String ||
        (itemsPerCarton != null &&
            (itemsPerCarton is! int || itemsPerCarton <= 0)) ||
        quantityPieces is! int ||
        sourceName is! String ||
        status is! String ||
        receivedAt is! Timestamp) {
      throw const FormatException('Malformed warehouse return data.');
    }

    return WarehouseReturnRecord(
      id: id,
      returnNumber: returnNumber,
      itemId: itemId,
      itemName: itemName,
      itemCode: itemCode,
      itemsPerCarton: itemsPerCarton as int?,
      quantityPieces: quantityPieces,
      sourceName: sourceName,
      status: _statusFrom(status),
      receivedAt: receivedAt.toDate(),
    );
  }

  static WarehouseReturnStatus _statusFrom(String value) {
    for (final status in WarehouseReturnStatus.values) {
      if (status.name == value) {
        return status;
      }
    }
    throw const FormatException('Malformed warehouse return status.');
  }
}
