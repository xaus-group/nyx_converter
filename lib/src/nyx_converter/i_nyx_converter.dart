import 'dart:typed_data';

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

  /// Returns detailed information about a media file.
  ///
  /// Information is obtained using FFprobe.
  ///
  /// The returned object contains:
  /// - file name
  /// - media format/container
  /// - file size
  /// - duration
  /// - whether the file contains video
  /// - whether the file contains audio
  /// - video codec
  /// - video resolution
  /// - video FPS
  /// - video bitrate
  /// - audio codec
  /// - audio bitrate
  /// - audio sample rate
  /// - audio channel count
  ///
  /// Returns `null` when FFprobe cannot read the media file.
  ///
  /// Example:
  ///
  /// ```dart
  /// final info = await NyxConverter.getMediaInfo(filePath);
  ///
  /// if (info != null) {
  ///   print(info.fileName);
  ///   print(info.duration);
  ///   print(info.video?.codec);
  ///   print(info.video?.width);
  ///   print(info.video?.height);
  /// }
  /// ```
  Future<NyxMediaInfo?> getMediaInfo(String inputPath);

  /// Generates a thumbnail from a media file.
  ///
  /// The thumbnail is generated from the first video frame and returned
  /// directly as JPEG bytes.
  ///
  /// The package creates and removes its own temporary file internally,
  /// so the caller does not need to provide an output path.
  ///
  /// Returns `null` when:
  /// - the media cannot be read,
  /// - the media does not contain a video stream,
  /// - or FFmpeg fails to generate the thumbnail.
  ///
  /// Example:
  ///
  /// ```dart
  /// final thumbnail = await NyxConverter.getThumbnail(filePath);
  ///
  /// if (thumbnail != null) {
  ///   Image.memory(thumbnail);
  /// }
  /// ```
  Future<Uint8List?> getThumbnail(String inputPath);

  /// ### Description:
  /// - The [kill] function terminates all `nyx_converter` process.
  ///
  /// ### Example:
  /// ```dart
  /// NyxConverter.kill();
  /// ```
  void kill();
}
