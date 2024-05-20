///
/// ### Description:
/// Video codecs, short for coder-decoders, are the unsung heroes that enable us to store and share videos efficiently. They act like **compression wizards**, shrinking massive video files by cleverly discarding redundant information while maintaining an acceptable level of visual quality.
///
/// Here's a quick breakdown:
///
/// - **Quality vs. File Size:** H.264 offers a good balance. H.265 provides higher compression but may require more processing power and have limited playback compatibility.
/// - **Compatibility:** H.264 is the most widely supported choice.
/// - **Application:** For web video, VP8/VP9 might be suitable.

/// Video codecs are constantly evolving, with newer ones offering better compression and features. However, compatibility across devices and platforms remains a factor to consider.
///
/// ### Example:
/// ```dart
/// final filePath = 'path/to/my.mp4';
/// final outputPath = 'path/to/';
///
/// NyxConverter.convertTo(filePath, outputPath, videoCodec: NyxVideoCodec.h264);
/// ```
enum NyxVideoCodec {
  /// The current king of video codecs, offering a great balance between high quality and efficient compression. Widely supported by devices and platforms, making it a versatile choice.
  h264,

  /// The successor to H.264, boasting even better compression for smaller file sizes with similar quality. However, it requires more processing power for encoding and decoding, and playback compatibility is still catching up.
  h265,

  /// An open-source implementation of the MPEG-4 standard, known for its efficiency and compatibility with older devices. Not as widely used now as H.264 and H.265.
  xvid,

  /// Open-source codec developed by Google, often used for web video streaming like YouTube. They prioritize good compression for efficient delivery over the internet.
  vp8,

  /// Open-source codecs developed by Google, often used for web video streaming like YouTube. They prioritize good compression for efficient delivery over the internet.
  vp9,

  /// A newer royalty-free alternative to H.265, aiming for similar compression efficiency with lower processing demands. Still gaining adoption and may not be universally supported yet.
  av1,

  /// A broad term encompassing various standards, including H.264 (AVC). It can also refer to the MPEG-4 Part 2 video codec, a predecessor to H.264 but less efficient and not as widely used.
  mpeg4,

  /// An older video codec standard, commonly used for DVDs and broadcast television. It's not as efficient as newer codecs like H.264, resulting in larger file sizes for similar quality.
  mpeg2
}

extension NyxVideoCodecCommandExtension on NyxVideoCodec {
  String get command {
    switch (this) {
      case NyxVideoCodec.h264:
        return 'libx264';
      case NyxVideoCodec.h265:
        return 'libx265';
      case NyxVideoCodec.xvid:
        return 'libxvid';
      case NyxVideoCodec.vp8:
        return 'libvpx';
      case NyxVideoCodec.vp9:
        return 'libvpx-vp9';
      case NyxVideoCodec.av1:
        return 'libaom-av1';
      case NyxVideoCodec.mpeg4:
        return 'mpeg4';
      case NyxVideoCodec.mpeg2:
        return 'mpeg2video';
    }
  }
}

extension NyxVideoCodecTitleExtension on NyxVideoCodec {
  String get title {
    switch (this) {
      case NyxVideoCodec.h264:
        return 'Advanced Video Coding (AVC)';
      case NyxVideoCodec.h265:
        return 'High Efficiency Video Coding (HEVC)';
      case NyxVideoCodec.xvid:
        return 'Xvid MPEG-4 Video Codec';
      case NyxVideoCodec.vp8:
        return 'On2 VP8';
      case NyxVideoCodec.vp9:
        return 'Google VP9';
      case NyxVideoCodec.av1:
        return 'AOMedia Video 1';
      case NyxVideoCodec.mpeg4:
        return 'MPEG-4 Part 2';
      case NyxVideoCodec.mpeg2:
        return 'MPEG-2 Video';
    }
  }
}

extension NyxVideoCodecNameExtension on NyxVideoCodec {
  String get name {
    switch (this) {
      case NyxVideoCodec.h264:
        return 'H.264';
      case NyxVideoCodec.h265:
        return 'H.265';
      case NyxVideoCodec.xvid:
        return 'Xvid';
      case NyxVideoCodec.vp8:
        return 'VP8';
      case NyxVideoCodec.vp9:
        return 'VP9';
      case NyxVideoCodec.av1:
        return 'AV1';
      case NyxVideoCodec.mpeg4:
        return 'MPEG-4';
      case NyxVideoCodec.mpeg2:
        return 'MPEG-2';
    }
  }
}
