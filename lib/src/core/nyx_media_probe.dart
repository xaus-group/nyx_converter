import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';

abstract final class NyxMediaProbe {
  NyxMediaProbe._();

  /// Returns `true` when FFprobe can read the media file.
  ///
  /// This verifies that the file:
  /// - exists
  /// - is a supported media format
  /// - is not corrupted
  /// - contains at least one media stream
  static Future<bool> isValidMedia(String inputPath) async {
    final session = await FFprobeKit.getMediaInformation(inputPath);

    final info = session.getMediaInformation();

    if (info == null) {
      return false;
    }

    return info.getStreams().isNotEmpty;
  }

  /// Returns the media duration in seconds.
  ///
  /// Returns `null` if the duration cannot be determined.
  static Future<double?> getDuration(String inputPath) async {
    final session = await FFprobeKit.getMediaInformation(inputPath);

    final info = session.getMediaInformation();

    if (info == null) {
      return null;
    }

    return double.tryParse(info.getDuration() ?? '');
  }
}
