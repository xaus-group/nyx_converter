import 'package:flutter_test/flutter_test.dart';
import 'package:nyx_converter/src/core/nyx_command_builder.dart';

void main() {
  group('NyxCommandBuilder', () {
    test('command should contain input and output files', () {
      final command = NyxCommandBuilder.build(
        inputPath: '/input/video.mp4',
        outputFilePath: '/output/video.mp4',
      );

      expect(
        command.contains('-i'),
        true,
      );

      expect(
        command.contains('/input/video.mp4'),
        true,
      );

      expect(
        command.contains('/output/video.mp4'),
        true,
      );
    });
  });
}
