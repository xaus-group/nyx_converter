import 'dart:io';
import 'dart:typed_data';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

abstract final class NyxThumbnail {
  NyxThumbnail._();

  /// Generates a JPEG thumbnail from a video.
  ///
  /// [position] specifies the position in the video where the thumbnail
  /// should be extracted.
  ///
  /// When [position] is not provided, the first frame is used.
  ///
  /// A temporary file is created internally and removed automatically.
  ///
  /// Returns the JPEG bytes, or `null` when the thumbnail cannot be created.
  static Future<Uint8List?> generate(
    String inputPath, {
    Duration? position,
  }) async {
    final inputFile = File(inputPath);

    if (!inputFile.existsSync()) {
      return null;
    }

    final tempDirectory = Directory.systemTemp;

    final thumbnailFile = File(
      '${tempDirectory.path}/'
      'nyx_thumbnail_${DateTime.now().microsecondsSinceEpoch}.jpg',
    );

    try {
      final outputPath = thumbnailFile.path;

      final positionArgument =
          position != null ? '-ss ${_formatDuration(position)} ' : '';

      final command = '$positionArgument'
          '-i "$inputPath" '
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

  /// Converts a [Duration] into an FFmpeg-compatible timestamp.
  ///
  /// Example:
  /// `Duration(minutes: 1, seconds: 5, milliseconds: 500)`
  /// becomes:
  /// `00:01:05.500`
  static String _formatDuration(Duration duration) {
    final hours = duration.inHours;

    final minutes = duration.inMinutes.remainder(60);

    final seconds = duration.inSeconds.remainder(60);

    final milliseconds = duration.inMilliseconds.remainder(1000);

    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${twoDigits(hours)}:'
        '${twoDigits(minutes)}:'
        '${twoDigits(seconds)}.'
        '${milliseconds.toString().padLeft(3, '0')}';
  }
}
