import 'package:flutter_test/flutter_test.dart';
import 'package:nyx_converter/src/helper/nyx_verify_error.dart';
import 'package:nyx_converter/src/nyx_converter/nyx_helper.dart';

void main() {
  group('Nyx Helper', () {
    group('NyxHelper.verifyData', () {
      test(
        'returns outputDirectoryNotFound when output directory does not exist',
        () async {
          final result = await NyxHelper().validate(
            inputPath: 'assets/videos/test_video.mp4',
            outputFilePath: 'unknown/output.mp4',
          );

          expect(result.isSuccess, false);
          expect(
            result.error,
            NyxVerifyError.outputDirectoryNotFound,
          );
        },
      );

      test(
        'returns outputFileAlreadyExists when output file already exists',
        () async {
          final result = await NyxHelper().validate(
            inputPath: 'assets/videos/test_video.mp4',
            outputFilePath: 'assets/videos/test_video.mp4',
          );

          expect(result.isSuccess, false);
          expect(
            result.error,
            NyxVerifyError.outputFileAlreadyExists,
          );
        },
      );

      test(
        'returns inputFileNotFound when input file does not exist',
        () async {
          final result = await NyxHelper().validate(
            inputPath: 'assets/videos/not_found.mp4',
            outputFilePath: 'assets/videos/output.mp4',
          );

          expect(result.isSuccess, false);
          expect(
            result.error,
            NyxVerifyError.inputFileNotFound,
          );
        },
      );
    });

    test("ffmpeg command should start with '-i'.", () {
      bool actual = true;
      String command = NyxHelper()
          .getCommand('assets/videos/test_video.avi.mp4', 'assets/videos/');
      if (!command.contains('-i')) {
        actual = false;
      }

      expect(actual, true);
    });

    test('The file name should not be an empty string.', () {
      bool actual = true;
      String fileBaseName =
          NyxHelper().getFileBaseName('assets/videos/test_video.avi.mp4');
      if (fileBaseName != 'test_video.avi') {
        actual = false;
      }

      expect(actual, true);
    });

    test('The file container should not be an empty string.', () {
      bool actual = true;
      String container =
          NyxHelper().getFileContainer('assets/videos/test_video.avi.mp4');
      if (container != '.mp4') {
        actual = false;
      }

      expect(actual, true);
    });

    test('Filename should not contain these characters [|\\?\<\":\+\[\]\/]',
        () {
      bool actual = true;
      String regex = '[|\\?\<\":\+\[\]\/]';

      for (var i = 0; i < regex.length; i++) {
        if (NyxHelper().verifyFileName(regex[i])) {
          actual = false;
        }
      }

      expect(actual, true);
    });
  });
}
