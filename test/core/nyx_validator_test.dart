import 'package:flutter_test/flutter_test.dart';
import 'package:nyx_converter/src/core/nyx_validator.dart';
import 'package:nyx_converter/src/models/nyx_verify_error.dart';

void main() {
  group('NyxValidator', () {
    test('returns error when input does not exist', () async {
      final result = await NyxValidator.validate(
        inputPath: 'unknown.mp4',
        outputFilePath: 'output.mp4',
      );

      expect(
        result.error,
        NyxVerifyError.inputFileNotFound,
      );
    });
  });
}
