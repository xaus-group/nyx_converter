import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nyx_converter/src/helper/nyx_verify_error.dart';
import 'package:nyx_converter/src/nyx_converter/nyx_helper.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<String> getAssetPath(String asset) async {
    final data = await rootBundle.load(asset);

    final directory = await getTemporaryDirectory();

    final file = File('${directory.path}/${asset.split('/').last}');

    await file.writeAsBytes(data.buffer.asUint8List());

    return file.path;
  }

  group('NyxHelper FFprobe integration', () {
    testWidgets('valid media file should pass verification', (tester) async {
      final inputPath = await getAssetPath('assets/videos/test_video.mp4');

      final result = await NyxHelper().validate(
        inputPath: inputPath,
        outputFilePath: '${Directory.systemTemp.path}/output.mp4',
      );

      expect(result.isSuccess, true);
    });

    testWidgets('invalid media file should fail verification', (tester) async {
      final inputPath = await getAssetPath('assets/videos/fake.mp4');

      final temp = await getTemporaryDirectory();

      final result = await NyxHelper().validate(
        inputPath: inputPath,
        outputFilePath: '${temp.path}/output.mp4',
      );

      expect(result.isSuccess, false);

      expect(result.error, NyxVerifyError.inputMediaInvalid);
    });
  });
}
