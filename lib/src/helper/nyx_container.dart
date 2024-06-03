///
/// ### Description:
/// Media file containers, sometimes called wrappers, are the digital equivalent of filing cabinets for your audio and video. They don't determine the content itself, but rather how it's organized and stored. Here's a quick breakdown:
///
/// - **Structure:** They define the overall layout of the file, including headers that identify the container format, data chunks for video, audio, subtitles, and other elements, and information on how these elements work together.
/// - **Flexibility:** Some containers, like MKV (Matroska Multimedia Container), are like spacious cabinets that can hold various types of encoded data (video codecs, audio codecs, subtitles). Others, like MOV (Apple QuickTime Movie), might be more specific, designed for a particular ecosystem.
///
/// Key Points:
/// - The container format doesn't affect the quality of the media itself. That's determined by the codecs used for encoding the video and audio.
/// - Choosing the right container format depends on your needs. If compatibility is crucial, MP4 is a safe bet. For maximum flexibility and features, MKV might be better.
///
/// ### Example:
/// ```dart
/// final filePath = 'path/to/my.mp4';
/// final outputPath = 'path/to/';
///
/// NyxConverter.convertTo(filePath, outputPath, container: NyxContainer.mp4);
/// ```
///
enum NyxContainer {
  // ****video****

  ///  An older format that stores video and audio together, like a classic filing cabinet for multimedia. Less common now, but still usable with many programs.
  avi,

  /// The current champ, super versatile and compatible with most devices. It's like a universal box that can hold different video and audio formats (codecs) within itself.
  mp4,

  /// he super-flexible option. It's like a feature-rich file cabinet that can hold multiple video tracks, subtitles, chapters, and more, all in one place.
  mkv,

  /// Primarily used by Apple for their devices and software. Similar to MP4 in terms of holding different codecs, but might not play as smoothly on non-Apple products.
  mov,

  /// Often linked to the Vorbis audio codec, but OGG itself is the container. Think of it as a box designed for open-source software, sometimes used for web applications.
  ogg,
  // ****audio****

  /// Stores audio with the highest quality, like an exact replica, but results in large file sizes.
  wav,

  /// FLAC is a popular open-source container format designed specifically for lossless audio compression. It efficiently reduces file size without any loss of audio quality
  flac,
}

extension NyxContainerCommandExtension on NyxContainer {
  String get command {
    switch (this) {
      case NyxContainer.avi:
        return 'avi';
      case NyxContainer.mp4:
        return 'mp4';
      case NyxContainer.mkv:
        return 'mkv';
      case NyxContainer.mov:
        return 'mov';
      case NyxContainer.ogg:
        return 'ogg';
      case NyxContainer.wav:
        return 'wav';
      case NyxContainer.flac:
        return 'flac';
    }
  }
}

extension NyxContainerNameExtension on NyxContainer {
  String get name {
    switch (this) {
      case NyxContainer.avi:
        return 'AVI (Audio Video Interleaved)';
      case NyxContainer.mp4:
        return 'MP4 (MPEG-4 Part 14)';
      case NyxContainer.mkv:
        return 'MKV (Matroska Video)';
      case NyxContainer.mov:
        return 'QuickTime / MOV';
      case NyxContainer.ogg:
        return 'Ogg';
      case NyxContainer.wav:
        return 'WAV / WAVE (Waveform Audio)';
      case NyxContainer.flac:
        return 'raw FLAC';
    }
  }
}
