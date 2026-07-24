import 'package:nyx_converter/nyx_converter.dart';

abstract class INyxConverter {
  /// Converts a media file to a new format.
  ///
  /// The conversion runs asynchronously. Progress and status updates can be
  /// received through the optional [execution] callback.
  ///
  /// The output file is validated before the conversion starts. If validation
  /// fails (for example, the input file does not exist or the output file already
  /// exists), the conversion is aborted and [execution] is invoked with
  /// [NyxStatus.failed].
  ///
  /// Parameters:
  /// - [filePath]: Path to the source media file.
  /// - [outputPath]: Directory where the converted file will be saved.
  /// - [container]: Target container format. Defaults to the source container.
  /// - [videoCodec]: Target video codec.
  /// - [audioCodec]: Target audio codec.
  /// - [fileName]: Output file name without the extension.
  /// - [audioBitrate]: Audio bitrate in kbps.
  /// - [videoBitrate]: Video bitrate in Mbps.
  /// - [debugMode]: Enables FFmpeg log output.
  /// - [execution]: Optional callback that receives conversion status updates.
  ///
  /// Example:
  /// ```dart
  /// await NyxConverter.convertTo(
  ///   '/storage/input.mp4',
  ///   '/storage/output',
  ///   container: NyxContainer.mkv,
  ///   videoCodec: NyxVideoCodec.h264,
  ///   audioCodec: NyxAudioCodec.aac,
  ///   videoBitrate: 5,
  ///   audioBitrate: 320,
  ///   fileName: 'holiday',
  ///   execution: (
  ///     status, {
  ///     progress,
  ///     fps,
  ///     speed,
  ///     errorMessage,
  ///   }) {
  ///     switch (status) {
  ///       case NyxStatus.running:
  ///         print(progress);
  ///         break;
  ///
  ///       case NyxStatus.completed:
  ///         print('Done!');
  ///         break;
  ///
  ///       case NyxStatus.failed:
  ///         print(errorMessage);
  ///         break;
  ///
  ///       case NyxStatus.cancel:
  ///         print('Cancelled');
  ///         break;
  ///     }
  ///   },
  /// );
  /// ```
  Future<void> convertTo(
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
    NyxConvertionCallback? execution,
  });

  /// ### Description:
  /// - The [kill] function terminates all `nyx_converter` process.
  ///
  /// ### Example:
  /// ```dart
  /// NyxConverter.kill();
  /// ```
  void kill();
}
