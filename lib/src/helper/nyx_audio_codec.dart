/// Represents an audio codec supported by Nyx Converter.
///
/// Audio codecs determine how audio is encoded during conversion.
///
/// Lossy codecs such as AAC, MP3, Opus, and Vorbis reduce file size
/// by discarding some audio information.
///
/// Lossless codecs such as FLAC and ALAC preserve the original audio
/// information while generally producing larger files.
///
/// The actual availability of a codec depends on the FFmpeg build
/// used by the application.
enum NyxAudioCodec {
  /// Advanced Audio Coding (AAC).
  ///
  /// A widely supported lossy codec offering a good balance between
  /// audio quality, file size, and compatibility.
  aac,

  /// MPEG-1/2 Audio Layer III (MP3).
  ///
  /// A highly compatible lossy codec supported by most devices,
  /// applications, and media players.
  mp3,

  /// Opus.
  ///
  /// A modern lossy codec designed for efficient audio compression.
  /// Particularly suitable for web, streaming, voice, and general
  /// purpose audio.
  opus,

  /// Ogg Vorbis.
  ///
  /// An open and patent-free lossy audio codec commonly used
  /// with the Ogg container.
  vorbis,

  /// MPEG-1/2 Audio Layer II (MP2).
  ///
  /// An older MPEG audio codec still used in some broadcast
  /// and legacy media workflows.
  mp2,

  /// Windows Media Audio (WMA).
  ///
  /// Microsoft's lossy audio codec.
  wma,

  /// Free Lossless Audio Codec (FLAC).
  ///
  /// A lossless codec that preserves the original audio information
  /// while reducing file size compared with uncompressed PCM.
  flac,

  /// Apple Lossless Audio Codec (ALAC).
  ///
  /// Apple's lossless audio codec, commonly used within the
  /// Apple ecosystem.
  alac,

  /// AC-3 (Dolby Digital).
  ///
  /// A lossy codec commonly used for DVD, broadcast, television,
  /// and home-theater audio.
  ac3,
}

/// Provides the FFmpeg encoder name for an audio codec.
extension NyxAudioCodecCommandExtension on NyxAudioCodec {
  /// FFmpeg encoder name used during conversion.
  ///
  /// Example:
  /// ```dart
  /// final encoder = NyxAudioCodec.aac.command;
  /// // aac
  /// ```
  String get command {
    switch (this) {
      case NyxAudioCodec.aac:
        return 'aac';

      case NyxAudioCodec.mp3:
        return 'libmp3lame';

      case NyxAudioCodec.opus:
        return 'libopus';

      case NyxAudioCodec.vorbis:
        return 'libvorbis';

      case NyxAudioCodec.mp2:
        return 'mp2';

      case NyxAudioCodec.wma:
        return 'wmav2';

      case NyxAudioCodec.flac:
        return 'flac';

      case NyxAudioCodec.alac:
        return 'alac';

      case NyxAudioCodec.ac3:
        return 'ac3';
    }
  }
}

/// Provides the full technical name of an audio codec.
extension NyxAudioCodecTitleExtension on NyxAudioCodec {
  /// Full technical codec name.
  String get title {
    switch (this) {
      case NyxAudioCodec.aac:
        return 'Advanced Audio Coding';

      case NyxAudioCodec.mp3:
        return 'MPEG-1/2 Audio Layer III';

      case NyxAudioCodec.opus:
        return 'Opus';

      case NyxAudioCodec.vorbis:
        return 'Ogg Vorbis';

      case NyxAudioCodec.mp2:
        return 'MPEG-1/2 Audio Layer II';

      case NyxAudioCodec.wma:
        return 'Windows Media Audio';

      case NyxAudioCodec.flac:
        return 'Free Lossless Audio Codec';

      case NyxAudioCodec.alac:
        return 'Apple Lossless Audio Codec';

      case NyxAudioCodec.ac3:
        return 'Dolby Digital (AC-3)';
    }
  }
}

/// Provides a short human-readable name for an audio codec.
extension NyxAudioCodecNameExtension on NyxAudioCodec {
  /// Short codec name.
  ///
  /// Example:
  /// ```dart
  /// print(NyxAudioCodec.aac.name);
  /// // AAC
  /// ```
  String get name {
    switch (this) {
      case NyxAudioCodec.aac:
        return 'AAC';

      case NyxAudioCodec.mp3:
        return 'MP3';

      case NyxAudioCodec.opus:
        return 'Opus';

      case NyxAudioCodec.vorbis:
        return 'Vorbis';

      case NyxAudioCodec.mp2:
        return 'MP2';

      case NyxAudioCodec.wma:
        return 'WMA';

      case NyxAudioCodec.flac:
        return 'FLAC';

      case NyxAudioCodec.alac:
        return 'ALAC';

      case NyxAudioCodec.ac3:
        return 'AC-3';
    }
  }
}
