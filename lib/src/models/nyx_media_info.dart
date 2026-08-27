/// Contains technical information about a media file.
///
/// The information is obtained from FFprobe and may contain video,
/// audio, or both streams.
///
/// Example:
///
/// ```dart
/// final info = await NyxConverter.getMediaInfo(filePath);
///
/// print(info.fileName);
/// print(info.format);
/// print(info.duration);
///
/// if (info.hasVideo) {
///   print(info.video?.codec);
///   print(info.video?.width);
///   print(info.video?.height);
///   print(info.video?.fps);
/// }
///
/// if (info.hasAudio) {
///   print(info.audio?.codec);
///   print(info.audio?.channels);
/// }
/// ```
class NyxMediaInfo {
  /// Name of the media file including its extension.
  final String fileName;

  /// Container/format reported by FFprobe.
  ///
  /// Examples:
  /// - `mp4`
  /// - `matroska,webm`
  /// - `mov`
  /// - `mp3`
  final String? format;

  /// Total media duration.
  final Duration? duration;

  /// File size in bytes.
  final int? size;

  /// Whether the media contains a video stream.
  final bool hasVideo;

  /// Whether the media contains an audio stream.
  final bool hasAudio;

  /// Information about the first video stream.
  ///
  /// `null` when the media does not contain a video stream.
  final NyxVideoInfo? video;

  /// Information about the first audio stream.
  ///
  /// `null` when the media does not contain an audio stream.
  final NyxAudioInfo? audio;

  const NyxMediaInfo({
    required this.fileName,
    this.format,
    this.duration,
    this.size,
    required this.hasVideo,
    required this.hasAudio,
    this.video,
    this.audio,
  });
}

/// Technical information about a video's stream.
class NyxVideoInfo {
  /// Video codec name reported by FFprobe.
  ///
  /// Examples:
  /// - `h264`
  /// - `hevc`
  /// - `vp9`
  /// - `av1`
  final String? codec;

  /// Video width in pixels.
  final int? width;

  /// Video height in pixels.
  final int? height;

  /// Video frame rate.
  final double? fps;

  /// Video bitrate in bits per second.
  final int? bitrate;

  const NyxVideoInfo({
    this.codec,
    this.width,
    this.height,
    this.fps,
    this.bitrate,
  });
}

/// Technical information about an audio stream.
class NyxAudioInfo {
  /// Audio codec name reported by FFprobe.
  ///
  /// Examples:
  /// - `aac`
  /// - `mp3`
  /// - `opus`
  /// - `flac`
  final String? codec;

  /// Audio bitrate in bits per second.
  final int? bitrate;

  /// Audio sample rate in Hz.
  final int? sampleRate;

  /// Number of audio channels.
  final int? channels;

  const NyxAudioInfo({
    this.codec,
    this.bitrate,
    this.sampleRate,
    this.channels,
  });
}
