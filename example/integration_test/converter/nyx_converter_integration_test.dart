import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nyx_converter/nyx_converter.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Copies an asset video into device storage.
  ///
  /// FFmpegKit works with real file paths,
  /// not Flutter asset paths.
  Future<String> getAssetPath(String asset) async {
    final data = await rootBundle.load(asset);

    final directory = await getTemporaryDirectory();

    final file = File('${directory.path}/${asset.split('/').last}');

    await file.writeAsBytes(data.buffer.asUint8List());

    return file.path;
  }

  group('NyxConverter integration', () {
    testWidgets('converts mp4 video successfully', (tester) async {
      final inputPath = await getAssetPath('assets/videos/test_video.mp4');

      final outputDirectory = (await getTemporaryDirectory()).path;

      String? finalOutputPath;

      NyxStatus? finalStatus;

      await NyxConverter.convertTo(
        inputPath,
        outputDirectory,

        container: NyxContainer.mp4,

        videoCodec: NyxVideoCodec.h264,

        audioCodec: NyxAudioCodec.aac,

        fileName: 'converted_video',

        execution:
            (
              NyxStatus status, {
              String? errorMessage,
              double? progress,
              double? fps,
              double? speed,
            }) {
              finalStatus = status;

              if (status == NyxStatus.completed) {
                finalOutputPath = '$outputDirectory/converted_video.mp4';
              }

              if (status == NyxStatus.failed) {
                fail(errorMessage ?? 'Conversion failed');
              }
            },
      );

      // Wait until FFmpeg finishes.
      await tester.pumpAndSettle(const Duration(seconds: 10));

      expect(finalStatus, NyxStatus.completed);

      expect(finalOutputPath, isNotNull);

      expect(File(finalOutputPath!).existsSync(), true);
    });

    testWidgets('fails when input file does not exist', (tester) async {
      final outputDirectory = (await getTemporaryDirectory()).path;

      NyxStatus? status;

      await NyxConverter.convertTo(
        '/unknown/video.mp4',
        outputDirectory,

        execution:
            (
              NyxStatus currentStatus, {
              String? errorMessage,
              double? progress,
              double? fps,
              double? speed,
            }) {
              status = currentStatus;
            },
      );

      await tester.pump();

      expect(status, NyxStatus.failed);
    });

    testWidgets('can cancel running conversion', (tester) async {
      final inputPath = await getAssetPath('assets/videos/test_video.mp4');

      final outputDirectory = (await getTemporaryDirectory()).path;

      bool started = false;

      NyxConverter.convertTo(
        inputPath,
        outputDirectory,

        fileName: 'cancel_test',

        execution:
            (
              NyxStatus status, {
              String? errorMessage,
              double? progress,
              double? fps,
              double? speed,
            }) {
              if (status == NyxStatus.running) {
                started = true;

                NyxConverter.kill();
              }
            },
      );

      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(started, true);
    });
  });
}
