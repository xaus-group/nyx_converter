import 'package:flutter_test/flutter_test.dart';
import 'package:nyx_converter/nyx_converter.dart';

void main() {
  group('NyxAudioCodec', () {
    test('all codecs should have valid properties', () {
      for (final codec in NyxAudioCodec.values) {
        expect(codec.command, isA<String>());
        expect(codec.command, isNotEmpty);

        expect(codec.name, isNotEmpty);
        expect(codec.title, isNotEmpty);
      }
    });

    test('codec command should not contain spaces', () {
      for (final codec in NyxAudioCodec.values) {
        expect(
          codec.command.contains(' '),
          false,
        );
      }
    });
  });
}
