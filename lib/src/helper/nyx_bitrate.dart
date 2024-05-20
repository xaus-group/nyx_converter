///
/// ### Description:
/// **Think of bitrate as the data highway for your media.** It refers to the amount of data (measured in bits) processed or transferred per second in a media file. The higher the bitrate, the more data is used to create the file, which translates to:
///
/// - **Better Quality:**  More data allows for storing finer details in the video or audio, resulting in sharper images and clearer sounds.
/// - **Larger File Sizes:**  With more data packed in, the file size naturally increases.
/// - **Faster Streaming/Playback:**  Higher bitrate files require a faster internet connection or playback device to handle the data flow smoothly.
///
///Key Points:
/// - Bitrate is not directly related to resolution (e.g., 1080p) - videos at the same resolution can have different bitrates depending on the amount of data used to encode them.
/// - Choosing the right bitrate depends on your needs. For online sharing, a balance between quality and file size might be ideal. For archival purposes, preserving the highest quality might be the priority, even with a larger file size.
///
/// ### Example:
/// ```dart
/// final filePath = 'path/to/my.mp4';
/// final outputPath = 'path/to/';
///
/// NyxConverter.convertTo(filePath, outputPath, bitrate: NyxBitrate.k320);
/// ```
///
enum NyxBitrate {
  /// This is considered the highest quality standard for MP3 audio. It offers a rich and detailed listening experience, close to the original recording. However, files at this bitrate will be the largest among the options listed.
  k320,

  /// offering a good balance between quality and file size. You might not hear a significant difference compared to 320kbps on most devices.
  k256,

  /// This bitrate provides decent audio quality, suitable for casual listening or streaming where bandwidth might be limited. You might start to notice a slight decrease in clarity compared to higher bitrates.
  k192,

  /// This is a common bitrate for music downloads or online streaming. It offers a significant reduction in file size compared to higher options, but the audio quality might sound noticeably compressed, with less detail and fullness.
  k128,

  /// It offers the smallest file size, the audio quality will be significantly compressed, with a noticeable loss of detail and clarity. It might be suitable for situations where file size is the absolute priority, but the listening experience will be less enjoyable.
  k96,
}

extension NyxBitrateCommandExtension on NyxBitrate {
  String get command {
    switch (this) {
      case NyxBitrate.k320:
        return '320k';
      case NyxBitrate.k256:
        return '256k';
      case NyxBitrate.k192:
        return '192k';
      case NyxBitrate.k128:
        return '128k';
      case NyxBitrate.k96:
        return '96k';
    }
  }
}

extension NyxBitrateNameExtension on NyxBitrate {
  String get title {
    switch (this) {
      case NyxBitrate.k320:
        return '320 Kbps';
      case NyxBitrate.k256:
        return '256 Kbps';
      case NyxBitrate.k192:
        return '192 Kbps';
      case NyxBitrate.k128:
        return '128 Kbps';
      case NyxBitrate.k96:
        return '96 Kbps';
    }
  }
}
