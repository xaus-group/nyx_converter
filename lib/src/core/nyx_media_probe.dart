import 'package:ffmpeg_kit_flutter_new/media_information.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_new/stream_information.dart';
import 'package:path/path.dart' as p;

import '../models/nyx_media_info.dart';

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

  /// Extracts detailed information about a media file using FFprobe.
  ///
  /// Returns information including:
  ///
  /// - file name
  /// - container format
  /// - duration
  /// - file size
  /// - video codec
  /// - video resolution
  /// - video bitrate
  /// - video FPS
  /// - audio codec
  /// - audio bitrate
  /// - audio sample rate
  /// - audio channels
  ///
  /// Supports both video and audio-only files.
  ///
  /// Throws an exception if FFprobe cannot read the file.
  static Future<NyxMediaInfo> getMediaInfo(
    String inputPath,
  ) async {
    final session = await FFprobeKit.getMediaInformation(inputPath);

    final MediaInformation? info = session.getMediaInformation();

    if (info == null) {
      throw Exception(
        'Unable to read media information.',
      );
    }

    final streams = info.getStreams();

    StreamInformation? videoStream;
    StreamInformation? audioStream;

    for (final stream in streams) {
      final type = stream.getType();

      if (type == 'video') {
        videoStream = stream;
      }

      if (type == 'audio') {
        audioStream = stream;
      }
    }

    final videoProperties = videoStream?.getAllProperties();

    final audioProperties = audioStream?.getAllProperties();

    return NyxMediaInfo(
      fileName: p.basename(inputPath),
      format: info.getFormat(),
      duration: _parseDuration(
        info.getDuration(),
      ),
      size: int.tryParse(
        info.getSize()?.toString() ?? '',
      ),
      hasVideo: videoStream != null,
      hasAudio: audioStream != null,
      video: videoStream == null
          ? null
          : NyxVideoInfo(
              codec: videoProperties?['codec_name']?.toString(),
              width: int.tryParse(
                videoProperties?['width']?.toString() ?? '',
              ),
              height: int.tryParse(
                videoProperties?['height']?.toString() ?? '',
              ),
              bitrate: int.tryParse(
                videoProperties?['bit_rate']?.toString() ?? '',
              ),
              fps: _parseFps(
                videoProperties?['r_frame_rate']?.toString(),
              ),
            ),
      audio: audioStream == null
          ? null
          : NyxAudioInfo(
              codec: audioProperties?['codec_name']?.toString(),
              bitrate: int.tryParse(
                audioProperties?['bit_rate']?.toString() ?? '',
              ),
              sampleRate: int.tryParse(
                audioProperties?['sample_rate']?.toString() ?? '',
              ),
              channels: int.tryParse(
                audioProperties?['channels']?.toString() ?? '',
              ),
            ),
    );
  }

  /// Converts FFprobe duration seconds into Dart Duration.
  static Duration? _parseDuration(
    String? value,
  ) {
    final seconds = double.tryParse(value ?? '');

    if (seconds == null) {
      return null;
    }

    return Duration(
      milliseconds: (seconds * 1000).round(),
    );
  }

  /// Converts FFprobe frame rate values.
  ///
  /// Example:
  ///
  /// 30000/1001 -> 29.97
  ///
  static double? _parseFps(
    String? value,
  ) {
    if (value == null) {
      return null;
    }

    final parts = value.split('/');

    if (parts.length != 2) {
      return double.tryParse(value);
    }

    final numerator = double.tryParse(parts[0]);

    final denominator = double.tryParse(parts[1]);

    if (numerator == null || denominator == null || denominator == 0) {
      return null;
    }

    return numerator / denominator;
  }
}
