import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
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

  /// Returns detailed information about the media file.
  ///
  /// FFprobe is used to inspect the container and its streams.
  ///
  /// The first video and first audio streams are used when multiple
  /// streams are present.
  ///
  /// Returns `null` when FFprobe cannot read the file.
  static Future<NyxMediaInfo?> getMediaInfo(String inputPath) async {
    final file = File(inputPath);

    if (!file.existsSync()) {
      return null;
    }

    final session = await FFprobeKit.getMediaInformation(inputPath);
    final info = session.getMediaInformation();

    if (info == null) {
      return null;
    }

    final streams = info.getStreams();

    if (streams.isEmpty) {
      return null;
    }

    dynamic videoStream;
    dynamic audioStream;

    for (final stream in streams) {
      if (stream.getType() == 'video' && videoStream == null) {
        videoStream = stream;
      }

      if (stream.getType() == 'audio' && audioStream == null) {
        audioStream = stream;
      }
    }

    NyxVideoInfo? video;

    if (videoStream != null) {
      video = NyxVideoInfo(
        codec: videoStream.getCodec(),
        width: _parseInt(videoStream.getWidth()),
        height: _parseInt(videoStream.getHeight()),
        fps: _parseFrameRate(videoStream),
        bitrate: _parseInt(videoStream.getBitrate()),
      );
    }

    NyxAudioInfo? audio;

    if (audioStream != null) {
      audio = NyxAudioInfo(
        codec: audioStream.getCodec(),
        bitrate: _parseInt(audioStream.getBitrate()),
        sampleRate: _parseInt(audioStream.getSampleRate()),
        channels: _parseChannels(audioStream),
      );
    }

    final duration = _parseDuration(info.getDuration());

    final format = info.getFormat();

    return NyxMediaInfo(
      fileName: p.basename(inputPath),
      format: format,
      duration: duration,
      size: file.lengthSync(),
      hasVideo: videoStream != null,
      hasAudio: audioStream != null,
      video: video,
      audio: audio,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) {
      return null;
    }

    return int.tryParse(value.toString());
  }

  static Duration? _parseDuration(dynamic value) {
    if (value == null) {
      return null;
    }

    final seconds = double.tryParse(value.toString());

    if (seconds == null || seconds < 0) {
      return null;
    }

    return Duration(
      microseconds: (seconds * Duration.microsecondsPerSecond).round(),
    );
  }

  static double? _parseFrameRate(dynamic stream) {
    try {
      final frameRate = stream.getRealFrameRate();

      if (frameRate != null) {
        final value = frameRate.toString();

        if (value.contains('/')) {
          final parts = value.split('/');

          if (parts.length == 2) {
            final numerator = double.tryParse(parts[0]);
            final denominator = double.tryParse(parts[1]);

            if (numerator != null && denominator != null && denominator != 0) {
              return numerator / denominator;
            }
          }
        }

        return double.tryParse(value);
      }
    } catch (_) {
      // Some FFprobe versions do not expose real frame rate.
    }

    return null;
  }

  static int? _parseChannels(dynamic stream) {
    try {
      final value = stream.getChannels();

      return _parseInt(value);
    } catch (_) {
      return null;
    }
  }
}
