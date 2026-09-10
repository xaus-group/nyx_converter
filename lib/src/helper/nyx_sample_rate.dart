/// Represents the audio sample rate used during conversion.
///
/// The sample rate defines how many samples are taken from an audio
/// signal per second. It is measured in Hertz (Hz).
///
/// Common sample rates include 44.1 kHz and 48 kHz.
enum NyxSampleRate {
  /// 48,000 samples per second (48 kHz).
  ///
  /// Commonly used for video, film, television, and professional
  /// audio workflows.
  hz48000,

  /// 44,100 samples per second (44.1 kHz).
  ///
  /// Commonly used for music and CD-quality audio.
  hz44100,

  /// 22,050 samples per second (22.05 kHz).
  ///
  /// Suitable for speech, voice, and applications where reducing
  /// audio data size is more important than preserving high-frequency
  /// audio detail.
  hz22050,
}

/// Provides the FFmpeg sample rate value.
///
/// The returned value can be passed to FFmpeg using the `-ar` option.
///
/// Example:
/// ```dart
/// final sampleRate = NyxSampleRate.hz48000.command;
/// // 48000
/// ```
extension NyxSampleRateCommandExtension on NyxSampleRate {
  /// Sample rate value used by FFmpeg.
  String get command {
    switch (this) {
      case NyxSampleRate.hz48000:
        return '48000';

      case NyxSampleRate.hz44100:
        return '44100';

      case NyxSampleRate.hz22050:
        return '22050';
    }
  }
}

/// Provides a human-readable name for an audio sample rate.
///
/// Example:
/// ```dart
/// print(NyxSampleRate.hz44100.title);
/// // 44100 Hz
/// ```
extension NyxSampleRateTitleExtension on NyxSampleRate {
  /// Display name of the sample rate.
  String get title {
    switch (this) {
      case NyxSampleRate.hz48000:
        return '48000 Hz';

      case NyxSampleRate.hz44100:
        return '44100 Hz';

      case NyxSampleRate.hz22050:
        return '22050 Hz';
    }
  }
}

/// Provides full human-readable names for [NyxSampleRate].
extension NyxSampleRateNameExtension on NyxSampleRate {
  /// Returns the sample rate in Hertz.
  ///
  /// Example:
  ///
  /// ```dart
  /// NyxSampleRate.hz48000.name;
  /// // 48000 Hz
  /// ```
  String get name {
    switch (this) {
      case NyxSampleRate.hz48000:
        return '48000 Hz';
      case NyxSampleRate.hz44100:
        return '44100 Hz';
      case NyxSampleRate.hz22050:
        return '22050 Hz';
    }
  }
}
