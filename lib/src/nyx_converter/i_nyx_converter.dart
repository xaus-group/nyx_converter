import 'package:nyx_converter/nyx_converter.dart';

abstract class INyxConverter {
  ///
  /// ### Parameters:
  /// - [filePath] (String): The path to the input media file.
  /// - [outputPath] (String): The desired path for the converted output file. (e.g., "/storage/emulated/0/Movies") (imp: Do not save video media files in the corresponding audio directories and vice versa)
  /// - [container] (NyxContainer, optional): The target format for the converted file (e.g., "mp4", "avi").
  /// - [videoCodec] (NyxVideoCodec, optional): The desired video codec for the converted file (e.g., "h264", "vp8").
  /// - [audioCodec] (NyxAudioCodec, optional): The desired audio codec for the converted file (e.g., "aac", "mp3").
  /// - [fileName] (String, optional): change output file name.
  ///
  /// - [debugMode] (bool, optional): By setting this item to true, you can get more detailed logs of nyx_converter processes.
  // - [size] (NyxSize, optional): The target width and height of the converted video in pixels.
  /// - [audioBitrate] (int, optional): The desired bitrate of the converted file in kilobits per second (kbps). (common bitrates: 128 kbps, 192 kbps, 320 kbps)
  /// - [videoBitrate] (int, optional): The desired bitrate of the converted file in megabits per second (Mbps). (common bitrates: 1 Mbps, 2.5 Mbps, 5 Mbps, 10 Mbps)
  // - [frequency] (NyxFrequency, optional): The target sampling frequency of the converted audio stream in Hertz (Hz).
  // - [channelLayout] (NyxChannelLayout, optional): The desired number of audio channels (1 for mono, 2 for stereo) in the converted file.
  //
  // ### Return Type:
  // - [Future<NyxData>]: The function returns a [Future] that resolves to a [NyxData] object
  ///
  /// - [execution]  (Function, required): A callback function that will be called during the conversion process. The callback receives these arguments:
  ///
  ///   - [status] (NyxStatus, required): The current status of the conversion process.
  ///     Possible values:
  ///       - `NyxStatus.running`
  ///       - `NyxStatus.completed`
  ///       - `NyxStatus.cancel`
  ///       - `NyxStatus.failed`
  ///   - [progress] (double?, optional): Represents the conversion progress percentage (0–100%).
  ///   - [fps] (double?, optional): Real-time processing speed in frames per second.
  ///   - [speed] (double?, optional): Real-time conversion speed.
  ///   - [errorMessage] (String, optional): Contains failure details when `NyxStatus.failed` is triggered.
  ///
  /// ### Description:
  /// - The [convertTo] function initiates the asynchronous process of converting a media file from the specified [filePath] to a new file at the provided [outputPath]. It offers various optional parameters to customize the output format, codecs, resolution, bitrate, and etc.
  ///
  /// ### Example:
  /// ```dart
  /// final filePath = 'path/to/my.mp4';
  /// final outputPath = 'converted_video.avi';
  ///
  /// NyxConverter.convertTo(filePath, outputPath,
  ///      container: NyxContainer.mp4,
  ///      videoCodec: NyxVideoCodec.h264,
  ///      audioCodec: NyxAudioCodec.aac,
  ///      audioBitrate: 320, // kbps
  ///      videoBitrate: 5, // Mbps
  ///      debugMode: true,
  ///      fileName: 'new_name',
  ///      execution: (
  ///       NyxStatus status, {
  ///       String? errorMessage,
  ///       double? progress,
  ///       double? fps,
  ///       double? speed
  ///       }) {}
  /// );
  /// ```
  ///
  convertTo(
    String filePath,
    String outputPath, {
    NyxContainer? container,
    NyxVideoCodec? videoCodec,
    NyxAudioCodec? audioCodec,
    // NyxSize? size,
    int? audioBitrate,
    int? videoBitrate,
    // NyxFrequency? frequency,
    // NyxChannelLayout? channelLayout
    bool debugMode = false,
    String? fileName,
    Function(
      NyxStatus status, {
      String? errorMessage,
      double? progress,
      double? fps,
      double? speed,
    }) execution,
  });

  /// ### Description:
  /// - The [kill] function terminates all `nyx_converter` process.
  ///
  /// ### Example:
  /// ```dart
  /// NyxConverter.kill();
  /// ```
  kill();
}
