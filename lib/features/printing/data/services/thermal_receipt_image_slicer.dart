import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

class ThermalReceiptImageSlice {
  final Uint8List bytes;
  final int width;
  final int height;

  const ThermalReceiptImageSlice({
    required this.bytes,
    required this.width,
    required this.height,
  });
}

class ThermalReceiptImageSlicer {
  // At 576 dots, 512 monochrome rows are about 36 KB. This stays safely below
  // the XP-P802A 64 KB input buffer while keeping the number of slices small.
  static const int maxSliceHeight = 512;
  static const int _maxRasterPayloadBytes = 40 * 1024;

  const ThermalReceiptImageSlicer();

  Future<List<ThermalReceiptImageSlice>> slicePng(Uint8List imageBytes) async {
    final dimensions = _readPngDimensions(imageBytes);
    if (dimensions == null) {
      return const [];
    }

    final (width, height) = dimensions;
    final safeSliceHeight = _safeSliceHeight(width);
    if (height <= safeSliceHeight) {
      return [
        ThermalReceiptImageSlice(
          bytes: imageBytes,
          width: width,
          height: height,
        ),
      ];
    }

    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final sourceImage = frame.image;

    try {
      final slices = <ThermalReceiptImageSlice>[];
      final decodedSliceHeight = _safeSliceHeight(sourceImage.width);
      for (var top = 0; top < sourceImage.height; top += decodedSliceHeight) {
        final sliceHeight = math.min(
          decodedSliceHeight,
          sourceImage.height - top,
        );
        slices.add(
          await _cropSlice(
            sourceImage: sourceImage,
            top: top,
            height: sliceHeight,
          ),
        );
      }
      return List.unmodifiable(slices);
    } finally {
      sourceImage.dispose();
      codec.dispose();
    }
  }

  int _safeSliceHeight(int imageWidth) {
    final bytesPerRasterRow = (imageWidth + 7) ~/ 8;
    final heightWithinBuffer = _maxRasterPayloadBytes ~/ bytesPerRasterRow;
    return math.max(1, math.min(maxSliceHeight, heightWithinBuffer));
  }

  Future<ThermalReceiptImageSlice> _cropSlice({
    required ui.Image sourceImage,
    required int top,
    required int height,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.drawColor(const ui.Color(0xFFFFFFFF), ui.BlendMode.src);
    canvas.drawImageRect(
      sourceImage,
      ui.Rect.fromLTWH(
        0,
        top.toDouble(),
        sourceImage.width.toDouble(),
        height.toDouble(),
      ),
      ui.Rect.fromLTWH(0, 0, sourceImage.width.toDouble(), height.toDouble()),
      ui.Paint(),
    );

    final picture = recorder.endRecording();
    final sliceImage = await picture.toImage(sourceImage.width, height);
    picture.dispose();

    try {
      final byteData = await sliceImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        throw StateError('Failed to encode the thermal receipt image slice.');
      }

      return ThermalReceiptImageSlice(
        bytes: byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
        width: sourceImage.width,
        height: height,
      );
    } finally {
      sliceImage.dispose();
    }
  }

  (int, int)? _readPngDimensions(Uint8List bytes) {
    if (bytes.length < 24) {
      return null;
    }

    const pngSignature = <int>[137, 80, 78, 71, 13, 10, 26, 10];
    for (var index = 0; index < pngSignature.length; index++) {
      if (bytes[index] != pngSignature[index]) {
        return null;
      }
    }

    final data = ByteData.sublistView(bytes);
    final width = data.getUint32(16);
    final height = data.getUint32(20);
    if (width == 0 || height == 0) {
      return null;
    }
    return (width, height);
  }
}
