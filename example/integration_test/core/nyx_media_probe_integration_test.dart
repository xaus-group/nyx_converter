import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nyx_converter/src/core/nyx_media_probe.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Copies a test asset into a real device directory.
  ///
  /// Assets cannot always be accessed directly by native libraries
  /// like FFprobe, so we create a temporary physical file first.
  Future<String> getAssetPath(String asset) async {
    final data = await rootBundle.load(asset);

    final directory = await getTemporaryDirectory();

    final file = File('${directory.path}/${asset.split('/').last}');

    await file.writeAsBytes(data.buffer.asUint8List());

    return file.path;
  }

  group('NyxMediaProbe FFprobe integration', () {
    testWidgets('returns true for valid media file', (tester) async {
      final inputPath = await getAssetPath('assets/videos/test_video.mp4');

      final result = await NyxMediaProbe.isValidMedia(inputPath);

      expect(result, true);
    });

    testWidgets('returns false for invalid media file', (tester) async {
      final inputPath = await getAssetPath('assets/videos/fake.mp4');

      final result = await NyxMediaProbe.isValidMedia(inputPath);

      expect(result, false);
    });

    testWidgets('returns media duration', (tester) async {
      final inputPath = await getAssetPath('assets/videos/test_video.mp4');

      final duration = await NyxMediaProbe.getDuration(inputPath);

      expect(duration, isNotNull);
      expect(duration! > 0, true);
    });
  });
}
