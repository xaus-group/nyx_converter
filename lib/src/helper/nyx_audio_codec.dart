///
/// ### Description:
/// An audio codec, short for coder-decoder, is like a **miniaturization machine for sound**. It shrinks digital audio files by removing unnecessary information, allowing you to store and share music and audio more efficiently. This compression comes with a trade-off, though. While some codecs (like MP3) prioritize smaller file sizes, they might sacrifice some sound quality. Others (like FLAC) preserve the original quality but result in larger files.
///
/// Here's a quick breakdown:
///
/// - **Compresses audio:** Reduces file size for easier storage and transfer.
/// - **Quality vs. Size:** Lossy codecs (MP3, AAC) prioritize size with some quality loss. Lossless codecs (FLAC) maintain quality but have larger files.
/// - **Widely Used:** AAC is a popular choice for its balance of size and quality, found in MP4s, YouTube videos, and most devices.

/// Choosing the right audio codec depends on your needs. If you prioritize pristine sound, go lossless. For smaller files and broader compatibility, consider a lossy codec with adjustable quality settings.
///
/// ### Example:
/// ```dart
/// final filePath = 'path/to/my.mp4';
/// final outputPath = 'path/to/';
///
/// NyxConverter.convertTo(filePath, outputPath, audioCodec: NyxAudioCodec.mp3);
/// ```
///
enum NyxAudioCodec {
  /// The most widely used audio codec, known for its good balance between file size and sound quality. It's a lossy codec, meaning it discards some audio information during compression.A widely used lossy codec known for its good balance of quality and file size. However, some audio information is sacrificed during compression.
  mp3,

  /// Predecessor to MP3, offering lower quality but slightly smaller file sizes. Less common nowadays.
  mp2,

  /// Developed by Microsoft, WMA offers similar quality to MP3 at comparable bitrates. However, its compatibility is not as universal as MP3.
  wma,

  /// A modern and efficient lossy codec, generally considered to provide better audio quality than MP3 at similar bitrates. Widely used in MP4 files, YouTube videos, and most devices.
  aac,

  /// A free and open-source lossy codec known for its good quality and efficient compression. Often used in web applications and free software.
  oog,

  /// A popular lossless compression format that preserves the original audio quality without any information loss. FLAC files are typically larger than their lossy counterparts but ideal for archiving or high-fidelity audio.
  flac,

  /// Similar to FLAC, ALAC offers lossless compression but is primarily used by Apple devices and iTunes.
  alac,

  /// A high-resolution audio format that uses a different approach than traditional PCM (Pulse Code Modulation) codecs. DSD captures audio data in a more analog-like way, potentially offering very high fidelity, but requires specialized equipment for playback.
  dsd
}

extension NyxAudioCodecCommandExtension on NyxAudioCodec {
  String get command {
    switch (this) {
      case NyxAudioCodec.mp3:
        return 'libmp3lame';
      case NyxAudioCodec.mp2:
        return 'mp2';
      case NyxAudioCodec.wma:
        return 'wmav2';
      case NyxAudioCodec.aac:
        return 'aac';
      case NyxAudioCodec.oog:
        return 'libvorbis';
      case NyxAudioCodec.flac:
        return 'flac';
      case NyxAudioCodec.alac:
        return 'alas';
      case NyxAudioCodec.dsd:
        return 'dsd';
    }
  }
}

extension NyxAudioCodecTitleExtension on NyxAudioCodec {
  String get title {
    switch (this) {
      case NyxAudioCodec.mp3:
        return 'MPEG-1 Audio Layer III or MPEG-2 Audio Layer III';
      case NyxAudioCodec.mp2:
        return 'MPEG-1 Audio Layer II';
      case NyxAudioCodec.wma:
        return 'Windows Media Audio';
      case NyxAudioCodec.aac:
        return 'Advanced Audio Coding';
      case NyxAudioCodec.oog:
        return 'Ogg Vorbis';
      case NyxAudioCodec.flac:
        return 'Free Lossless Audio Codec';
      case NyxAudioCodec.alac:
        return 'Apple Lossless Audio Codec';
      case NyxAudioCodec.dsd:
        return 'Direct Stream Digital';
    }
  }
}

extension NyxAudioCodecNameExtension on NyxAudioCodec {
  String get name {
    switch (this) {
      case NyxAudioCodec.mp3:
        return 'MP3';
      case NyxAudioCodec.mp2:
        return 'MP2';
      case NyxAudioCodec.wma:
        return 'WMA';
      case NyxAudioCodec.aac:
        return 'AAC';
      case NyxAudioCodec.oog:
        return 'OGG';
      case NyxAudioCodec.flac:
        return 'FLAC';
      case NyxAudioCodec.alac:
        return 'ALAC';
      case NyxAudioCodec.dsd:
        return 'DSD';
    }
  }
}
