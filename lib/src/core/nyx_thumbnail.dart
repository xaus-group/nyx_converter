import 'dart:io';
import 'dart:typed_data';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

abstract final class NyxThumbnail {
  NyxThumbnail._();

  /// Generates a JPEG thumbnail from the first video frame.
  ///
  /// A temporary file is created internally and removed automatically.
  ///
  /// Returns the JPEG bytes, or `null` when the thumbnail cannot be created.
  static Future<Uint8List?> generate(String inputPath) async {
    final inputFile = File(inputPath);

    if (!inputFile.existsSync()) {
      return null;
    }

    final tempDirectory = Directory.systemTemp;

    final thumbnailFile = File(
      '${tempDirectory.path}/nyx_thumbnail_${DateTime.now().microsecondsSinceEpoch}.jpg',
    );

    try {
      final outputPath = thumbnailFile.path;

      final command = '-i "$inputPath" '
          '-frames:v 1 '
          '-q:v 2 '
          '"$outputPath"';

      final session = await FFmpegKit.execute(command);

      final returnCode = await session.getReturnCode();

      if (!ReturnCode.isSuccess(returnCode)) {
        return null;
      }

      if (!thumbnailFile.existsSync()) {
        return null;
      }

      return await thumbnailFile.readAsBytes();
    } catch (_) {
      return null;
    } finally {
      if (thumbnailFile.existsSync()) {
        try {
          await thumbnailFile.delete();
        } catch (_) {
          // Ignore cleanup errors.
        }
      }
    }
  }
}
