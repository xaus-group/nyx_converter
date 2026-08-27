class NyxMediaInfo {
  final String fileName;
  final String? format;
  final Duration? duration;
  final int? size;

  final bool hasVideo;
  final bool hasAudio;

  final NyxVideoInfo? video;
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

class NyxVideoInfo {
  final String? codec;
  final int? width;
  final int? height;
  final double? fps;
  final int? bitrate;

  const NyxVideoInfo({
    this.codec,
    this.width,
    this.height,
    this.fps,
    this.bitrate,
  });
}

class NyxAudioInfo {
  final String? codec;
  final int? bitrate;
  final int? sampleRate;
  final int? channels;

  const NyxAudioInfo({
    this.codec,
    this.bitrate,
    this.sampleRate,
    this.channels,
  });
}
