import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/printing/data/services/thermal_receipt_image_slicer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('keeps a short receipt as one unchanged image', () async {
    final imageBytes = await _createPng(width: 576, height: 400);

    final slices = await const ThermalReceiptImageSlicer().slicePng(imageBytes);

    expect(slices, hasLength(1));
    expect(slices.single.bytes, same(imageBytes));
    expect(slices.single.width, 576);
    expect(slices.single.height, 400);
  });

  test('splits a long receipt into bounded consecutive images', () async {
    final imageBytes = await _createPng(width: 576, height: 1200);

    final slices = await const ThermalReceiptImageSlicer().slicePng(imageBytes);

    expect(slices.map((slice) => slice.width), everyElement(576));
    expect(slices.map((slice) => slice.height), [512, 512, 176]);
    expect(slices.fold<int>(0, (height, slice) => height + slice.height), 1200);
    for (final slice in slices) {
      expect(_readPngDimensions(slice.bytes), (576, slice.height));
    }
  });
}

Future<Uint8List> _createPng({required int width, required int height}) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  canvas.drawColor(const ui.Color(0xFFFFFFFF), ui.BlendMode.src);
  canvas.drawRect(
    ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    ui.Paint()..color = const ui.Color(0xFF000000),
  );
  final picture = recorder.endRecording();
  final image = await picture.toImage(width, height);
  picture.dispose();

  try {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw StateError('Failed to build the test PNG.');
    }
    return byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );
  } finally {
    image.dispose();
  }
}

(int, int) _readPngDimensions(Uint8List bytes) {
  final data = ByteData.sublistView(bytes);
  return (data.getUint32(16), data.getUint32(20));
}
