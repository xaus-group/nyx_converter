import 'package:flutter_test/flutter_test.dart';
import 'package:nyx_converter/src/helper/nyx_status.dart';

void main() {
  group('Nyx Status', () {
    test('Status title should be String type', () {
      bool actual = false;

      for (var status in NyxStatus.values) {
        if (status.title.runtimeType == String) {
          actual = true;
        }
      }

      expect(actual, true);
    });
  });
}
