import 'package:flutter_test/flutter_test.dart';
import 'package:nyx_converter/nyx_converter.dart';

void main() {
  group('Nyx Video Codec', () {
    test('Video Codecs command should be String type', () {
      bool actual = false;

      for (var codec in NyxVideoCodec.values) {
        if (codec.command.runtimeType == String &&
            codec.name.runtimeType == String) {
          actual = true;
        }
      }

      expect(actual, true);
    });

    test('Video Codecs command should not contain space', () {
      bool actual = false;

      for (var codec in NyxVideoCodec.values) {
        if (codec.command.split(' ').length == 1) {
          actual = true;
        }
      }

      expect(actual, true);
    });

    test('Video Codecs title should not be empty string', () {
      bool actual = false;

      for (var codec in NyxVideoCodec.values) {
        if (codec.title.isNotEmpty) {
          actual = true;
        }
      }

      expect(actual, true);
    });

    test('Video Codecs name should not be empty string', () {
      bool actual = false;

      for (var codec in NyxVideoCodec.values) {
        if (codec.name.isNotEmpty) {
          actual = true;
        }
      }

      expect(actual, true);
    });
  });
}
