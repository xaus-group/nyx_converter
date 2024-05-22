///
/// ### Description:
/// Channel layout refers to the specific arrangement and number of channels used for audio or video in a media file. It essentially tells you how many independent streams of audio or video information are present and how they are organized.
///
/// ### Example:
/// ```dart
/// final filePath = 'path/to/my.mp4';
/// final outputPath = 'path/to/';
///
/// NyxConverter.convertTo(filePath, outputPath, channelLayout: NyxChannelLayout.stereo);
/// ```
///
enum NyxChannelLayout {
  /// Utilizes two separate channels (left and right). Audio information is split between these channels, creating a wider and more immersive listening experience. Stereo allows for panning and positioning of sounds within the "stereo field," making the listening experience more natural and engaging.
  stereo,

  /// All audio information is combined into a single channel. This results in a flat, one-dimensional soundscape, like listening through one speaker. Common in older recordings, phone calls, and voice messages.
  mono
}

extension NyxChannelLayoutNameExtension on NyxChannelLayout {
  String get title {
    switch (this) {
      case NyxChannelLayout.stereo:
        return 'Stereo';
      case NyxChannelLayout.mono:
        return 'Mono';
    }
  }
}
