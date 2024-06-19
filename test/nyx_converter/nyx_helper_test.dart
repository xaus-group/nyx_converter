import 'package:flutter_test/flutter_test.dart';
import 'package:nyx_converter/nyx_converter.dart';
import 'package:nyx_converter/src/helper/verify_data.dart';
import 'package:nyx_converter/src/nyx_converter/nyx_helper.dart';

void main() {
  group('Nyx Helper', () {
    test("verifyData method should not cause an exception error.", () {
      bool actual = false;

      VerifyData verifyData = NyxHelper().verifyData(
          'assets/videos/test_video.avi.mp4',
          'assets/videos/',
          NyxContainer.mp4.command,
          fileName: 'abc');
      if (verifyData.status == NyxStatus.success) {
        actual = true;
      }

      expect(actual, true);
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
