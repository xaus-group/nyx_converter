import 'package:nyx_converter/nyx_converter.dart';

abstract class INyxConverter {
  ///
  /// ### Parameters:
  /// - [filePath] (String): The path to the input media file.
  /// - [outputPath] (String): The desired path for the converted output file. (e.g., "/storage/emulated/0/Movies") (imp: Do not save video media files in the corresponding audio directories and vice versa)
  /// - [container] (NyxContainer, optional): The target format for the converted file (e.g., "mp4", "avi").
  // - [debug] (bool, optional): By setting this item to true, you can get more detailed logs of nyx_converter processes.
  // - [fileName] (String, optional): change output file name.
  // - [videoCodec] (NyxVideoCodec, optional): The desired video codec for the converted file (e.g., "h264", "vp8").
  // - [audioCodec] (NyxAudioCodec, optional): The desired audio codec for the converted file (e.g., "aac", "mp3").
  // - [size] (NyxSize, optional): The target width and height of the converted video in pixels.
  // - [bitrate] (NyxBitrate, optional): The desired bitrate of the converted file in kilobits per second (kbps).
  // - [frequency] (NyxFrequency, optional): The target sampling frequency of the converted audio stream in Hertz (Hz).
  // - [channelLayout] (NyxChannelLayout, optional): The desired number of audio channels (1 for mono, 2 for stereo) in the converted file.
  //
  // ### Return Type:
  // - [Future<NyxData>]: The function returns a [Future] that resolves to a [NyxData] object
  ///
  /// - [fileName] (String, optional): change output file name.
  ///
  /// - [debugMode] (bool, optional): By setting this item to true, you can get more detailed logs of nyx_converter processes.
  ///
  /// - [execution]  (Function, required): A callback function that will be called during the conversion process. The callback receives three arguments:
  ///
  ///   - [path] (String): The temporary path to the converted file during processing (might be null).
  ///   - [status] (NyxStatus): The current status of the conversion process.
  ///   - [errorMessage] (String, optional): An optional message related to conversion process errors.
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
  ///      NyxContainer.mp4,
  ///      debugMode: true,
  ///      fileName: 'new_name',
  ///      execution: (String? path, NyxStatus status, {String? errorMessage}) {}
  /// );
  /// ```
  ///
  convertTo(
    String filePath,
    String outputPath, {
    NyxContainer? container,
    // NyxVideoCodec? videoCodec,
    // NyxAudioCodec? audioCodec,
    // NyxSize? size,
    // NyxBitrate? bitrate,
    // NyxFrequency? frequency,
    // NyxChannelLayout? channelLayout
    bool debugMode = false,
    String? fileName,
    Function(String? path, NyxStatus status, {String? errorMessage}) execution,
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
