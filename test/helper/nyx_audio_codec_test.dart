import 'package:flutter_test/flutter_test.dart';
import 'package:nyx_converter/nyx_converter.dart';

void main() {
  group('Nyx Audio Codec', () {
    test('Audio Codecs command should be String type', () {
      bool actual = false;

      for (var codec in NyxAudioCodec.values) {
        if (codec.command.runtimeType == String &&
            codec.name.runtimeType == String) {
          actual = true;
        }
      }

      expect(actual, true);
    });

    test('Audio Codecs command should not contain space', () {
      bool actual = false;

      for (var codec in NyxAudioCodec.values) {
        if (codec.command.split(' ').length == 1) {
          actual = true;
        }
      }

      expect(actual, true);
    });

    test('Audio Codecs title should not be empty string', () {
      bool actual = false;

      for (var codec in NyxAudioCodec.values) {
        if (codec.title.isNotEmpty) {
          actual = true;
        }
      }

      expect(actual, true);
    });

    test('Audio Codecs name should not be empty string', () {
      bool actual = false;

      for (var codec in NyxAudioCodec.values) {
        if (codec.name.isNotEmpty) {
          actual = true;
        }
      }

      expect(actual, true);
    });
  });
}
