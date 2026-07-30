import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/movement_record.dart';

/// Validates and maps Firestore movement documents into feature models.
class MovementRecordFirestoreMapper {
  const MovementRecordFirestoreMapper._();

  static MovementRecord fromMap({
    required String id,
    required Map<String, dynamic> data,
  }) {
    final voucherNumber = data['voucherNumber'];
    final type = data['type'];
    final businessAt = data['businessAt'];
    final partyName = data['partyName'];
    final deliveredBy = data['deliveredBy'];
    final receivedBy = data['receivedBy'];
    final driverName = data['driverName'];
    final notes = data['notes'];
    final rawLines = data['lines'];
    final rawItemDeltas = data['itemDeltas'];

    if (voucherNumber is! String ||
        type is! String ||
        businessAt is! Timestamp ||
        partyName is! String ||
        deliveredBy is! String ||
        receivedBy is! String ||
        driverName is! String ||
        notes is! String ||
        rawLines is! List ||
        rawItemDeltas is! Map) {
      throw const FormatException('Malformed movement data.');
    }

    final lines = rawLines.map(_lineFromMap).toList(growable: false);
    final itemDeltas = <String, int>{};
    for (final entry in rawItemDeltas.entries) {
      if (entry.key is! String || entry.value is! int) {
        throw const FormatException('Malformed movement item deltas.');
      }
      itemDeltas[entry.key as String] = entry.value as int;
    }

    return MovementRecord(
      id: id,
      voucherNumber: voucherNumber,
      type: _movementTypeFrom(type),
      businessAt: businessAt.toDate(),
      partyName: partyName,
      deliveredBy: deliveredBy,
      receivedBy: receivedBy,
      driverName: driverName,
      notes: notes,
      lines: lines,
      itemDeltas: Map.unmodifiable(itemDeltas),
    );
  }

  static MovementRecordType _movementTypeFrom(String value) {
    for (final type in MovementRecordType.values) {
      if (type.name == value) {
        return type;
      }
    }
    throw const FormatException('Malformed movement type.');
  }

  static MovementRecordLine _lineFromMap(Object? rawLine) {
    if (rawLine is! Map) {
      throw const FormatException('Malformed movement line.');
    }

    final line = Map<String, dynamic>.from(rawLine);
    final itemId = line['itemId'];
    final itemCode = line['itemCode'];
    final itemName = line['itemName'];
    final unit = line['unit'];
    final itemsPerCarton = line['itemsPerCarton'];
    final cartons = line['cartons'];
    final pieces = line['pieces'];
    final totalPieces = line['totalPieces'];
    if (itemId is! String ||
        itemCode is! String ||
        itemName is! String ||
        unit is! String ||
        itemsPerCarton is! int ||
        cartons is! int ||
        pieces is! int ||
        totalPieces is! int) {
      throw const FormatException('Malformed movement line.');
    }

    return MovementRecordLine(
      itemId: itemId,
      itemCode: itemCode,
      itemName: itemName,
      unit: unit,
      itemsPerCarton: itemsPerCarton,
      cartons: cartons,
      pieces: pieces,
      totalPieces: totalPieces,
    );
  }
}
