import '../models/nyx_media_type.dart';

/// Represents a media container or audio media format used during conversion.
///
/// A container determines how video, audio, subtitles, metadata, and
/// other media streams are organized inside a file.
///
/// The container itself does not determine whether the resulting file should
/// be treated as audio or video. That is determined by the streams contained
/// in the media file.
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
  mpeg,

  /// Windows Media / ASF.
  wmv,

  /// Ogg container.
  ///
  /// Ogg may contain either audio or video streams.
  ogg,

  /// WAV (Waveform Audio File Format).
  wav,

  /// FLAC audio format.
  flac,

  /// MP3 audio format.
  mp3,

  /// AAC audio format using an ADTS stream.
  aac,
}

/// Provides the FFmpeg output format identifier.
extension NyxContainerCommandExtension on NyxContainer {
  /// FFmpeg output format identifier.
  ///
  /// This value can be passed to FFmpeg using the `-f` option.
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

/// Provides the file extension used for the generated file.
extension NyxContainerExtensionExtension on NyxContainer {
  /// File extension without the leading dot.
  String get extension {
    switch (this) {
      case NyxContainer.avi:
        return 'avi';
      case NyxContainer.mp4:
        return 'mp4';
      case NyxContainer.mkv:
        return 'mkv';
      case NyxContainer.mov:
        return 'mov';
      case NyxContainer.webM:
        return 'webm';
      case NyxContainer.mpeg:
        return 'mpeg';
      case NyxContainer.wmv:
        return 'wmv';
      case NyxContainer.ogg:
        return 'ogg';
      case NyxContainer.wav:
        return 'wav';
      case NyxContainer.flac:
        return 'flac';
      case NyxContainer.mp3:
        return 'mp3';
      case NyxContainer.aac:
        return 'aac';
    }
  }
}

/// Provides a human-readable display name for a [NyxContainer].
extension NyxContainerNameExtension on NyxContainer {
  /// Full display name.
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

/// Provides a short display title for a [NyxContainer].
extension NyxContainerTitleExtension on NyxContainer {
  /// Concise display title.
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

/// Provides the MIME type associated with a [NyxContainer] and media type.
///
/// The media type is determined from the actual streams in the media file.
/// This is important because some containers, such as Ogg and Matroska,
/// can contain either audio or video.
///
/// Example:
///
/// ```dart
/// NyxContainer.ogg.mimeType(NyxMediaType.audio);
/// // audio/ogg
///
/// NyxContainer.ogg.mimeType(NyxMediaType.video);
/// // video/ogg
/// ```
extension NyxContainerMimeTypeExtension on NyxContainer {
  /// Returns the MIME type for this container and [mediaType].
  String mimeType(NyxMediaType mediaType) {
    switch (this) {
      case NyxContainer.avi:
        return 'video/x-msvideo';

      case NyxContainer.mp4:
        switch (mediaType) {
          case NyxMediaType.video:
            return 'video/mp4';
          case NyxMediaType.audio:
            return 'audio/mp4';
        }

      case NyxContainer.mkv:
        switch (mediaType) {
          case NyxMediaType.video:
            return 'video/x-matroska';
          case NyxMediaType.audio:
            return 'audio/x-matroska';
        }

      case NyxContainer.mov:
        switch (mediaType) {
          case NyxMediaType.video:
            return 'video/quicktime';
          case NyxMediaType.audio:
            return 'audio/quicktime';
        }

      case NyxContainer.webM:
        switch (mediaType) {
          case NyxMediaType.video:
            return 'video/webm';
          case NyxMediaType.audio:
            return 'audio/webm';
        }

      case NyxContainer.mpeg:
        switch (mediaType) {
          case NyxMediaType.video:
            return 'video/mpeg';
          case NyxMediaType.audio:
            return 'audio/mpeg';
        }

      case NyxContainer.wmv:
        switch (mediaType) {
          case NyxMediaType.video:
            return 'video/x-ms-wmv';
          case NyxMediaType.audio:
            return 'audio/x-ms-wma';
        }

      case NyxContainer.ogg:
        switch (mediaType) {
          case NyxMediaType.video:
            return 'video/ogg';
          case NyxMediaType.audio:
            return 'audio/ogg';
        }

      case NyxContainer.wav:
        return 'audio/wav';

      case NyxContainer.flac:
        return 'audio/flac';

      case NyxContainer.mp3:
        return 'audio/mpeg';

      case NyxContainer.aac:
        return 'audio/aac';
    }
  }
}
