/// Represents a video codec used during conversion.
///
/// A video codec determines how video frames are encoded and compressed.
/// Different codecs provide different trade-offs between visual quality,
/// compression efficiency, encoding speed, and compatibility.
///
/// Codec availability depends on the FFmpeg build used by the application.
enum NyxVideoCodec {
  /// H.264 / AVC (Advanced Video Coding).
  ///
  /// Provides a good balance between video quality, compression efficiency,
  /// encoding speed, and compatibility. It is one of the most widely
  /// supported video codecs.
  h264,

  /// H.265 / HEVC (High Efficiency Video Coding).
  ///
  /// Generally provides better compression efficiency than H.264 at
  /// similar visual quality, but encoding can require more processing
  /// power and device compatibility may be more limited.
  h265,

  /// Xvid MPEG-4 Part 2 video codec.
  ///
  /// An older MPEG-4 Part 2 implementation commonly used for legacy
  /// video content and older media players.
  xvid,

  /// VP8 video codec.
  ///
  /// An open video codec commonly used for web-oriented video.
  /// It provides reasonable compression and broad support in
  /// web-related workflows.
  vp8,

  /// VP9 video codec.
  ///
  /// A successor to VP8 that generally provides better compression
  /// efficiency and is commonly used for web and streaming video.
  vp9,

  /// AV1 (AOMedia Video 1).
  ///
  /// A modern, royalty-free video codec designed for high compression
  /// efficiency. It can provide smaller files at similar visual quality,
  /// but encoding can be computationally demanding.
  av1,

  /// MPEG-4 Part 2 video codec.
  ///
  /// An older video codec that can be useful for compatibility with
  /// legacy media and devices.
  mpeg4,

  /// MPEG-2 video codec.
  ///
  /// An older video codec commonly associated with DVD, broadcast,
  /// and legacy video workflows.
  mpeg2,
}

/// Provides FFmpeg encoder names for [NyxVideoCodec].
///
/// The returned value is intended to be used with FFmpeg's `-c:v`
/// option.
///
/// Example:
///
/// ```dart
/// NyxVideoCodec.h264.command;
/// // libx264
/// ```
extension NyxVideoCodecCommandExtension on NyxVideoCodec {
  /// Returns the FFmpeg encoder name for this codec.
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

/// Provides full technology names for [NyxVideoCodec].
extension NyxVideoCodecTitleExtension on NyxVideoCodec {
  /// Returns the full codec technology name.
  ///
  /// Example:
  ///
  /// ```dart
  /// NyxVideoCodec.h264.title;
  /// // Advanced Video Coding (AVC)
  /// ```
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

/// Provides short display names for [NyxVideoCodec].
///
/// Useful when displaying codec names in Flutter widgets.
extension NyxVideoCodecNameExtension on NyxVideoCodec {
  /// Returns a short human-readable codec name.
  ///
  /// Example:
  ///
  /// ```dart
  /// NyxVideoCodec.h264.name;
  /// // H.264
  /// ```
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
