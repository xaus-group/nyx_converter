import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:path/path.dart' as p;

import '../helper/nyx_container.dart';
import '../models/nyx_media_info.dart';
import '../models/nyx_media_type.dart';

abstract final class NyxMediaProbe {
  NyxMediaProbe._();

  /// Returns `true` when FFprobe can read the media file.
  ///
  /// The file must exist, be readable by FFprobe, and contain
  /// at least one media stream.
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
  /// Returns `null` when the duration cannot be determined.
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
  /// The media type is determined dynamically from the available streams:
  ///
  /// - A video stream means [NyxMediaType.video].
  /// - An audio-only file means [NyxMediaType.audio].
  ///
  /// The MIME type is then generated from the detected container and
  /// media type.
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

    final hasVideo = videoStream != null;
    final hasAudio = audioStream != null;

    // A video stream takes priority.
    //
    // Therefore:
    // video + audio -> video
    // video only    -> video
    // audio only    -> audio
    final NyxMediaType mediaType;

    if (hasVideo) {
      mediaType = NyxMediaType.video;
    } else if (hasAudio) {
      mediaType = NyxMediaType.audio;
    } else {
      // FFprobe returned streams, but none are audio/video.
      // NyxMediaInfo currently represents audio/video media only.
      return null;
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

    final extension =
        p.extension(inputPath).replaceFirst('.', '').toLowerCase();

    final container = _containerFromExtension(extension);

    if (container == null) {
      return null;
    }

    final mimeType = container.mimeType(mediaType);

    return NyxMediaInfo(
      fileName: p.basename(inputPath),
      extension: extension,
      format: format,
      mediaType: mediaType,
      mimeType: mimeType,
      duration: duration,
      size: file.lengthSync(),
      hasVideo: hasVideo,
      hasAudio: hasAudio,
      video: video,
      audio: audio,
    );
  }

  static NyxContainer? _containerFromExtension(String extension) {
    for (final container in NyxContainer.values) {
      if (container.extension == extension) {
        return container;
      }
    }

    return null;
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
