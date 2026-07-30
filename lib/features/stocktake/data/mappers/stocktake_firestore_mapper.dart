import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/stocktake_line.dart';
import '../models/stocktake_session.dart';

/// Validates and maps Firestore stocktake documents into feature models.
class StocktakeFirestoreMapper {
  const StocktakeFirestoreMapper._();

  static StocktakeSession sessionFromMap({
    required String id,
    required Map<String, dynamic> data,
  }) {
    final stocktakeNumber = data['stocktakeNumber'];
    final status = data['status'];
    final periodFrom = data['periodFrom'];
    final periodTo = data['periodTo'];
    final startedAt = data['startedAt'];
    final completedAt = data['completedAt'];
    final cancelledAt = data['cancelledAt'];
    final notes = data['notes'];
    if (stocktakeNumber is! String ||
        status is! String ||
        periodFrom is! Timestamp ||
        periodTo is! Timestamp ||
        startedAt is! Timestamp ||
        completedAt is! Timestamp? ||
        cancelledAt is! Timestamp? ||
        notes is! String) {
      throw const FormatException('Malformed stocktake session.');
    }

    return StocktakeSession(
      id: id,
      stocktakeNumber: stocktakeNumber,
      status: _statusFrom(status),
      periodFrom: periodFrom.toDate(),
      periodTo: periodTo.toDate(),
      startedAt: startedAt.toDate(),
      completedAt: completedAt?.toDate(),
      cancelledAt: cancelledAt?.toDate(),
      notes: notes,
    );
  }

  static StocktakeStatus _statusFrom(String value) {
    for (final status in StocktakeStatus.values) {
      if (status.name == value) {
        return status;
      }
    }
    throw const FormatException('Malformed stocktake status.');
  }

  static StocktakeLine lineFromMap({
    required String itemId,
    required Map<String, dynamic> data,
  }) {
    final storedItemId = data['itemId'];
    final itemName = data['itemNameSnapshot'];
    final itemCode = data['itemCodeSnapshot'];
    final unit = data['unit'];
    final itemsPerCarton = data['itemsPerCarton'];
    final systemQuantity = data['systemQuantityPieces'];
    final actualQuantity = data['actualQuantityPieces'];
    final difference = data['differencePieces'];
    final counted = data['counted'];
    final countedAt = data['countedAt'];
    if (storedItemId != itemId ||
        itemName is! String ||
        itemCode is! String ||
        unit is! String ||
        itemsPerCarton is! int ||
        systemQuantity is! int ||
        actualQuantity is! int ||
        difference is! int ||
        counted is! bool ||
        countedAt is! Timestamp?) {
      throw const FormatException('Malformed stocktake line.');
    }

    return StocktakeLine(
      itemId: itemId,
      itemNameSnapshot: itemName,
      itemCodeSnapshot: itemCode,
      unit: unit,
      itemsPerCarton: itemsPerCarton,
      systemQuantityPieces: systemQuantity,
      actualQuantityPieces: actualQuantity,
      differencePieces: difference,
      counted: counted,
      countedAt: countedAt?.toDate(),
    );
  }
}
