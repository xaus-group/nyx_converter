import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';

abstract final class NyxThumbnail {
  NyxThumbnail._();

  /// Generates a thumbnail image from a media file.
  ///
  /// Uses FFmpeg to extract a frame.
  static Future<String> generate({
    required String inputPath,
    required String outputPath,
  }) async {
    final command = '-i "$inputPath" '
        '-ss 00:00:01 '
        '-frames:v 1 '
        '-q:v 2 '
        '"$outputPath"';

    final session = await FFmpegKit.execute(command);

    final returnCode = await session.getReturnCode();

    if (returnCode == null || !returnCode.isValueSuccess()) {
      throw Exception(
        'Failed to generate thumbnail.',
      );
    }

    if (!File(outputPath).existsSync()) {
      throw Exception(
        'Thumbnail file was not created.',
      );
    }

    return outputPath;
  }
}
