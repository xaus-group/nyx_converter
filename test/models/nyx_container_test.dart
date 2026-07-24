import 'package:flutter_test/flutter_test.dart';
import 'package:nyx_converter/nyx_converter.dart';

void main() {
  group('Nyx Container', () {
    test('Containers command should be String type', () {
      bool actual = false;

      for (var container in NyxContainer.values) {
        if (container.command.runtimeType == String &&
            container.name.runtimeType == String) {
          actual = true;
        }
      }

      expect(actual, true);
    });

    test('Containers command should not contain space', () {
      bool actual = false;

      for (var container in NyxContainer.values) {
        if (container.command.split(' ').length == 1) {
          actual = true;
        }
      }

      expect(actual, true);
    });

    test('Containers name should not be empty string', () {
      bool actual = false;

      for (var container in NyxContainer.values) {
        if (container.name.isNotEmpty) {
          actual = true;
        }
      }

      expect(actual, true);
    });
  });
}
