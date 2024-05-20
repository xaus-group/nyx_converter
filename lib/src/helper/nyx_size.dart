///
/// ### Description:
/// Video sizes are like footprints for your videos. This refers to the number of pixels that make up the video frame. More pixels generally mean sharper images and better quality, but also larger file sizes. The best size depends on what you're using the video for:
///
/// - **Online Sharing:** Consider platform recommendations and bandwidth limitations.
/// - **Video Quality:** Higher resolution offers better detail, but also larger file sizes.
/// - Target Audience: If viewers are mostly on mobile, a lower resolution with a vertical aspect ratio might be suitable. By understanding these basics, you can choose the video size that best balances quality and practicality for your project.
///
///
/// ### Example:
/// ```dart
/// final filePath = 'path/to/my.mp4';
/// final outputPath = 'path/to/';
///
/// NyxConverter.convertTo(filePath, outputPath, size: NyxSize.w1280h720);
/// ```
enum NyxSize {
  /// A lower resolution option, often used for video calls or applications where bandwidth is limited.
  w640h360,

  /// This was once the standard for DVDs and broadcast television. Still used for some web videos or legacy content.
  w640h480,

  /// A popular choice for online videos and Blu-ray discs. Offers a noticeable improvement over SD.
  w1280h720,

  /// The current "Full HD" standard, widely used for high-quality videos on streaming services, Blu-ray discs, and many devices.
  w1920h1080,

  /// Offers four times the resolution of 1080p, providing sharper images and better viewing experiences on large screens. Gaining popularity for high-end content creation and playback.
  w3840h2160
}

extension NyxSizeCommandExtension on NyxSize {
  String get command {
    switch (this) {
      case NyxSize.w640h360:
        return '640x360';
      case NyxSize.w640h480:
        return '640x480';
      case NyxSize.w1280h720:
        return '1280x720';
      case NyxSize.w1920h1080:
        return '1920x1080';
      case NyxSize.w3840h2160:
        return '3840x2160';
    }
  }
}

extension NyxSizeNameExtension on NyxSize {
  String get name {
    switch (this) {
      case NyxSize.w640h360:
        return '360p';
      case NyxSize.w640h480:
        return 'Standard Definition (SD)';
      case NyxSize.w1280h720:
        return 'High Definition (HD)';
      case NyxSize.w1920h1080:
        return 'Full HD';
      case NyxSize.w3840h2160:
        return 'Ultra High Definition (UHD) / 4K';
    }
  }
}
