///
/// ### Description:
/// Sample rate refers to the number of times per second an analog audio signal is converted into digital data.
///
/// Choosing the Right Sample Rate:
/// - **For critical listening or archiving:** Opt for higher sample rates (like 48000 Hz) to preserve the highest quality.
/// - **For most music and audio applications:** The standard 44100 Hz (CD quality) is a good choice.
/// - **For voice recordings or low-bandwidth situations:** Consider 22050 Hz, but be aware of the potential loss of audio detail.
///
///Remember, a higher sample rate generally results in a larger file size. Choose the sample rate that best suits your needs for audio quality and file size management.
///
/// ### Example:
/// ```dart
/// final filePath = 'path/to/my.mp4';
/// final outputPath = 'path/to/';
///
/// NyxConverter.convertTo(filePath, outputPath, frequency: NyxFrequency.hz48000);
/// ```
///
enum NyxFrequency {
  /// Capture more detail in the audio, resulting in a more accurate representation of the original sound. This is ideal for high-fidelity audio like classical music or recordings with a wide range of instruments. It also provides more flexibility for editing and manipulation without losing quality.
  hz48000,

  /// This is the standard sample rate for CDs and is considered high-quality for most audio applications. It offers a good balance between capturing detail and file size.
  hz44100,

  /// Capture less detail and might sound thinner or more muffled. This can be acceptable for certain applications like voice recordings, telephone conversations, or low-bandwidth situations where file size needs to be minimized. However, it's not ideal for music or high-fidelity audio.
  hz22050,
}

extension NyxFrequencyCommandExtension on NyxFrequency {
  String get command {
    switch (this) {
      case NyxFrequency.hz48000:
        return '48000';
      case NyxFrequency.hz44100:
        return '44100';
      case NyxFrequency.hz22050:
        return '22050';
    }
  }
}

extension NyxFrequencyNameExtension on NyxFrequency {
  String get title {
    switch (this) {
      case NyxFrequency.hz48000:
        return '48000 Hz';
      case NyxFrequency.hz44100:
        return '44100 Hz';
      case NyxFrequency.hz22050:
        return '22050 Hz';
    }
  }
}
