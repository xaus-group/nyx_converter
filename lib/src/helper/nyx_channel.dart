/// Represents the audio channel layout used during conversion.
///
/// A channel layout determines the number of audio channels in the
/// output media.
///
/// Nyx Converter currently supports mono and stereo audio.
enum NyxChannelLayout {
  /// Two audio channels: left and right.
  ///
  /// Stereo audio allows sounds to be positioned between the left
  /// and right channels.
  stereo,

  /// A single audio channel.
  ///
  /// Mono combines the audio into one channel and is commonly used
  /// for speech, voice recordings, and other single-channel audio.
  mono,
}

/// Provides a human-readable name for an audio channel layout.
///
/// Example:
/// ```dart
/// print(NyxChannelLayout.stereo.title);
/// // Stereo
/// ```
extension NyxChannelLayoutTitleExtension on NyxChannelLayout {
  /// Display name of the channel layout.
  String get title {
    switch (this) {
      case NyxChannelLayout.stereo:
        return 'Stereo';

      case NyxChannelLayout.mono:
        return 'Mono';
    }
  }
}

/// Provides the number of audio channels used by FFmpeg.
///
/// This value is intended to be used with FFmpeg's `-ac` option.
///
/// Example:
/// ```dart
/// final channels = NyxChannelLayout.stereo.command;
/// // 2
/// ```
extension NyxChannelLayoutCommandExtension on NyxChannelLayout {
  /// Number of audio channels passed to FFmpeg.
  ///
  /// Stereo uses 2 channels and mono uses 1 channel.
  String get command {
    switch (this) {
      case NyxChannelLayout.stereo:
        return '2';

      case NyxChannelLayout.mono:
        return '1';
    }
  }
}

/// Provides descriptive names for [NyxChannelLayout].
extension NyxChannelLayoutNameExtension on NyxChannelLayout {
  /// Returns the full human-readable name of the channel layout.
  ///
  /// Example:
  ///
  /// ```dart
  /// NyxChannelLayout.stereo.name;
  /// // Stereo (2 channels)
  /// ```
  String get name {
    switch (this) {
      case NyxChannelLayout.stereo:
        return 'Stereo (2 channels)';
      case NyxChannelLayout.mono:
        return 'Mono (1 channel)';
    }
  }
}
