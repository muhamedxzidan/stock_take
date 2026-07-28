import 'package:flutter_test/flutter_test.dart';
import 'package:stock_take/core/extensions/inventory_number_parsing.dart';

void main() {
  test('parses English and Arabic digit variants', () {
    expect('12'.toInventoryInteger(), 12);
    expect('١٢'.toInventoryInteger(), 12);
    expect('۱۲'.toInventoryInteger(), 12);
  });
}
