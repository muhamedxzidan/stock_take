import 'dart:typed_data';

import '../models/saved_printer.dart';
import 'thermal_receipt_image_slicer.dart';

typedef ReceiptImagePrinter =
    Future<bool> Function({
      required String address,
      required Uint8List imageBytes,
      required int imageWidth,
      required int imageHeight,
      required int addFeeds,
      required void Function(int total, int sent) onProgress,
    });

/// Sends a receipt image in buffer-safe slices without retrying printed slices.
class ThermalReceiptPrintJob {
  final ReceiptImageSlicer _sliceImage;
  final ReceiptImagePrinter _printImage;

  const ThermalReceiptPrintJob({
    required ReceiptImageSlicer sliceImage,
    required ReceiptImagePrinter printImage,
  }) : _sliceImage = sliceImage,
       _printImage = printImage;

  Future<bool> print({
    required SavedPrinter printer,
    required Uint8List imageBytes,
    required void Function(double progress) onProgress,
  }) async {
    final slices = await _sliceImage(imageBytes);
    if (slices.isEmpty) {
      return false;
    }

    for (var index = 0; index < slices.length; index++) {
      final slice = slices[index];
      final printed = await _printImage(
        address: printer.address,
        imageBytes: slice.bytes,
        imageWidth: slice.width,
        imageHeight: slice.height,
        addFeeds: index == slices.length - 1 ? 3 : 0,
        onProgress: (total, sent) {
          final sliceProgress = total <= 0
              ? 0.0
              : (sent / total).clamp(0.0, 1.0).toDouble();
          onProgress((index + sliceProgress) / slices.length);
        },
      );
      if (!printed) {
        return false;
      }
      onProgress((index + 1) / slices.length);
    }
    return true;
  }
}
