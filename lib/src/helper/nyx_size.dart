/// Represents a target video resolution used during conversion.
///
/// Video size defines the width and height of the output video in pixels.
///
/// Higher resolutions can provide more detail, but usually require more
/// storage space and higher bitrate. The appropriate resolution depends
/// on the target device, platform, and desired video quality.
enum NyxSize {
  /// 640x360 resolution (360p).
  ///
  /// A lower-resolution option suitable for small screens, previews,
  /// video calls, and situations where bandwidth or file size is limited.
  w640h360,

  /// 640x480 resolution (SD).
  ///
  /// A standard-definition 4:3 resolution commonly found in older
  /// video content and legacy media.
  w640h480,

  /// 854x480 resolution (480p SD).
  ///
  /// A widescreen standard-definition resolution, often used for
  /// online video with a 16:9 aspect ratio.
  w854h480,

  /// 1280x720 resolution (720p).
  ///
  /// A common HD resolution suitable for online video, streaming,
  /// and general-purpose video content.
  w1280h720,

  /// 1920x1080 resolution (1080p).
  ///
  /// Full HD resolution widely used for high-quality video,
  /// streaming, Blu-ray, and modern devices.
  w1920h1080,

  /// 2560x1440 resolution (1440p).
  ///
  /// Quad HD resolution, offering a balance between Full HD and 4K.
  w2560h1440,

  /// 3840x2160 resolution (4K UHD).
  ///
  /// Ultra-high-definition resolution suitable for high-detail
  /// content and large displays.
  w3840h2160,

  /// 1080x608 resolution.
  ///
  /// A custom cinematic widescreen resolution.
  w1080h608,

  /// 1080x1350 resolution.
  ///
  /// A vertical resolution often used for social media stories.
  w1080h1350,

  /// 1080x1080 resolution.
  ///
  /// A square resolution commonly used for social media posts.
  w1080h1080,

  /// 1080x1920 resolution.
  ///
  /// A vertical Full HD resolution for mobile-first content.
  w1080h1920,
}

/// Provides FFmpeg-compatible resolution values.
extension NyxSizeCommandExtension on NyxSize {
  /// Returns the video resolution in `WIDTHxHEIGHT` format.
  ///
  /// Example:
  ///
  /// ```dart
  /// NyxSize.w1920h1080.command;
  /// // 1920x1080
  /// ```
  String get command {
    switch (this) {
      case NyxSize.w640h360:
        return '640x360';
      case NyxSize.w640h480:
        return '640x480';
      case NyxSize.w854h480:
        return '854x480';
      case NyxSize.w1280h720:
        return '1280x720';
      case NyxSize.w1920h1080:
        return '1920x1080';
      case NyxSize.w2560h1440:
        return '2560x1440';
      case NyxSize.w3840h2160:
        return '3840x2160';
      case NyxSize.w1080h608:
        return '1080x608';
      case NyxSize.w1080h1350:
        return '1080x1350';
      case NyxSize.w1080h1080:
        return '1080x1080';
      case NyxSize.w1080h1920:
        return '1080x1920';
    }
  }
}

/// Provides human-readable names for video resolutions.
extension NyxSizeNameExtension on NyxSize {
  /// Returns the display name of the resolution.
  ///
  /// Example:
  ///
  /// ```dart
  /// NyxSize.w1920h1080.name;
  /// // Full HD
  /// ```
  String get name {
    switch (this) {
      case NyxSize.w640h360:
        return '360p';
      case NyxSize.w640h480:
        return 'Standard Definition (SD)';
      case NyxSize.w854h480:
        return '480p SD';
      case NyxSize.w1280h720:
        return 'High Definition (HD)';
      case NyxSize.w1920h1080:
        return 'Full HD';
      case NyxSize.w2560h1440:
        return 'Quad HD (QHD) / 1440p';
      case NyxSize.w3840h2160:
        return 'Ultra High Definition (UHD) / 4K';
      case NyxSize.w1080h608:
        return '1080 × 608';
      case NyxSize.w1080h1350:
        return '1080 × 1350';
      case NyxSize.w1080h1080:
        return '1080 × 1080';
      case NyxSize.w1080h1920:
        return '1080 × 1920';
    }
  }
}

/// Provides short titles for video resolutions.
extension NyxSizeTitleExtension on NyxSize {
  /// Returns a concise title for the resolution.
  ///
  /// Example:
  ///
  /// ```dart
  /// NyxSize.w1920h1080.title;
  /// // 1080p Full HD
  /// ```
  String get title {
    switch (this) {
      case NyxSize.w640h360:
        return '360p';
      case NyxSize.w640h480:
        return '480p';
      case NyxSize.w854h480:
        return '480p SD';
      case NyxSize.w1280h720:
        return '720p HD';
      case NyxSize.w1920h1080:
        return '1080p Full HD';
      case NyxSize.w2560h1440:
        return '1440p';
      case NyxSize.w3840h2160:
        return '4K UHD';
      case NyxSize.w1080h608:
        return '1080 × 608';
      case NyxSize.w1080h1350:
        return '1080 × 1350';
      case NyxSize.w1080h1080:
        return '1080 × 1080';
      case NyxSize.w1080h1920:
        return '1080 × 1920';
    }
  }
}
