import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/features/printing/data/models/saved_printer.dart';
import 'package:stock_take/features/printing/data/repositories/bluetooth_printer_repository.dart';
import 'package:stock_take/features/printing/data/services/thermal_receipt_image_slicer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const printer = SavedPrinter(address: '00:11:22:33:44:55', name: 'XP-P802A');

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  test(
    'prints receipt slices in order and feeds only after the last',
    () async {
      final calls = <_PrintCall>[];
      final progress = <double>[];
      final repository = BluetoothPrinterRepository(
        imageSlicer: (_) async => _threeSlices,
        imagePrinter:
            ({
              required address,
              required imageBytes,
              required imageWidth,
              required imageHeight,
              required addFeeds,
              required onProgress,
            }) async {
              calls.add(
                _PrintCall(
                  firstByte: imageBytes.first,
                  width: imageWidth,
                  height: imageHeight,
                  addFeeds: addFeeds,
                ),
              );
              onProgress(100, 50);
              onProgress(100, 100);
              return true;
            },
      );

      final printed = await repository.printReceiptPng(
        printer: printer,
        imageBytes: _validPngHeader,
        onProgress: progress.add,
      );

      expect(printed, isTrue);
      expect(calls.map((call) => call.firstByte), [1, 2, 3]);
      expect(calls.map((call) => call.width), everyElement(576));
      expect(calls.map((call) => call.height), [512, 512, 176]);
      expect(calls.map((call) => call.addFeeds), [0, 0, 3]);
      expect(progress, isNotEmpty);
      expect(progress.last, 1);
      expect(_isMonotonic(progress), isTrue);
    },
  );

  test('stops after a failed slice without retrying printed content', () async {
    final printedSlices = <int>[];
    final repository = BluetoothPrinterRepository(
      imageSlicer: (_) async => _threeSlices,
      imagePrinter:
          ({
            required address,
            required imageBytes,
            required imageWidth,
            required imageHeight,
            required addFeeds,
            required onProgress,
          }) async {
            printedSlices.add(imageBytes.first);
            return imageBytes.first != 2;
          },
    );

    final printed = await repository.printReceiptPng(
      printer: printer,
      imageBytes: _validPngHeader,
      onProgress: (_) {},
    );

    expect(printed, isFalse);
    expect(printedSlices, [1, 2]);
  });
}

final _threeSlices = <ThermalReceiptImageSlice>[
  ThermalReceiptImageSlice(
    bytes: Uint8List.fromList(const [1]),
    width: 576,
    height: 512,
  ),
  ThermalReceiptImageSlice(
    bytes: Uint8List.fromList(const [2]),
    width: 576,
    height: 512,
  ),
  ThermalReceiptImageSlice(
    bytes: Uint8List.fromList(const [3]),
    width: 576,
    height: 176,
  ),
];

final _validPngHeader = Uint8List.fromList([
  137,
  80,
  78,
  71,
  13,
  10,
  26,
  10,
  0,
  0,
  0,
  13,
  73,
  72,
  68,
  82,
  0,
  0,
  2,
  64,
  0,
  0,
  4,
  176,
]);

bool _isMonotonic(List<double> values) {
  for (var index = 1; index < values.length; index++) {
    if (values[index] < values[index - 1]) {
      return false;
    }
  }
  return true;
}

class _PrintCall {
  final int firstByte;
  final int width;
  final int height;
  final int addFeeds;

  const _PrintCall({
    required this.firstByte,
    required this.width,
    required this.height,
    required this.addFeeds,
  });
}
