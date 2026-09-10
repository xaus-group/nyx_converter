/// Represents a media container or audio media format used during conversion.
///
/// A container determines how video, audio, subtitles, metadata, and
/// other media streams are organized inside a file.
///
/// The container does not determine media quality. Quality is primarily
/// determined by the codecs and encoding settings used for the media streams.
enum NyxContainer {
  /// AVI (Audio Video Interleave).
  ///
  /// An older multimedia container with broad legacy support.
  avi,

  /// MP4 (MPEG-4 Part 14).
  ///
  /// A widely supported container suitable for most video applications.
  mp4,

  /// Matroska Multimedia Container.
  ///
  /// A flexible container supporting multiple video/audio tracks,
  /// subtitles, chapters, and metadata.
  mkv,

  /// QuickTime Movie.
  ///
  /// Apple's multimedia container format.
  mov,

  /// WebM.
  ///
  /// A web-oriented container commonly used for modern web video.
  webM,

  /// MPEG program stream.
  ///
  /// A container format commonly associated with MPEG-1 and MPEG-2
  /// video workflows.
  mpeg,

  /// Windows Media / ASF.
  ///
  /// Commonly used for Windows Media files such as `.wmv`.
  wmv,

  /// Ogg container.
  ///
  /// An open container commonly used with Vorbis and Opus audio.
  ogg,

  /// WAV (Waveform Audio File Format).
  ///
  /// Commonly used for uncompressed PCM audio.
  wav,

  /// FLAC audio format.
  ///
  /// A lossless audio format that preserves the original audio data.
  flac,

  /// MP3 audio format.
  ///
  /// A widely supported compressed audio format.
  mp3,

  /// AAC audio format.
  ///
  /// Typically used for AAC audio in an ADTS stream.
  aac,
}

/// Provides the FFmpeg output format identifier.
///
/// The returned value is passed to FFmpeg using the `-f` option
/// when an explicit output format is required.
extension NyxContainerCommandExtension on NyxContainer {
  /// FFmpeg output format identifier.
  String get command {
    switch (this) {
      case NyxContainer.avi:
        return 'avi';

      case NyxContainer.mp4:
        return 'mp4';

      case NyxContainer.mkv:
        return 'matroska';

      case NyxContainer.mov:
        return 'mov';

      case NyxContainer.webM:
        return 'webm';

      case NyxContainer.mpeg:
        return 'mpeg';

      case NyxContainer.wmv:
        return 'asf';

      case NyxContainer.ogg:
        return 'ogg';

      case NyxContainer.wav:
        return 'wav';

      case NyxContainer.flac:
        return 'flac';

      case NyxContainer.mp3:
        return 'mp3';

      case NyxContainer.aac:
        return 'adts';
    }
  }
}

/// Provides a human-readable display name for a media container
/// or audio format.
extension NyxContainerNameExtension on NyxContainer {
  /// Display name of the container or format.
  String get name {
    switch (this) {
      case NyxContainer.avi:
        return 'AVI (Audio Video Interleave)';

      case NyxContainer.mp4:
        return 'MP4 (MPEG-4 Part 14)';

      case NyxContainer.mkv:
        return 'MKV (Matroska)';

      case NyxContainer.mov:
        return 'MOV (QuickTime)';

      case NyxContainer.webM:
        return 'WebM';

      case NyxContainer.mpeg:
        return 'MPEG';

      case NyxContainer.wmv:
        return 'WMV (Windows Media / ASF)';

      case NyxContainer.ogg:
        return 'Ogg';

      case NyxContainer.wav:
        return 'WAV (Waveform Audio)';

      case NyxContainer.flac:
        return 'FLAC';

      case NyxContainer.mp3:
        return 'MP3 (MPEG Audio Layer III)';

      case NyxContainer.aac:
        return 'AAC (ADTS)';
    }
  }
}

/// Provides short display titles for [NyxContainer].
extension NyxContainerTitleExtension on NyxContainer {
  /// Returns a concise title for the container.
  ///
  /// Example:
  ///
  /// ```dart
  /// NyxContainer.mp4.title;
  /// // MP4
  /// ```
  String get title {
    switch (this) {
      case NyxContainer.avi:
        return 'AVI';
      case NyxContainer.mp4:
        return 'MP4';
      case NyxContainer.mkv:
        return 'MKV';
      case NyxContainer.mov:
        return 'MOV';
      case NyxContainer.webM:
        return 'WebM';
      case NyxContainer.mpeg:
        return 'MPEG';
      case NyxContainer.wmv:
        return 'WMV';
      case NyxContainer.ogg:
        return 'Ogg';
      case NyxContainer.wav:
        return 'WAV';
      case NyxContainer.flac:
        return 'FLAC';
      case NyxContainer.mp3:
        return 'MP3';
      case NyxContainer.aac:
        return 'AAC';
    }
  }
}
