import 'package:flutter_test/flutter_test.dart';
import 'package:nyx_converter/src/helper/nyx_status.dart';

void main() {
  group('NyxStatus', () {
    test('all statuses should have title', () {
      for (final status in NyxStatus.values) {
        expect(
          status.title,
          isNotEmpty,
        );
      }
    });
  });
}
