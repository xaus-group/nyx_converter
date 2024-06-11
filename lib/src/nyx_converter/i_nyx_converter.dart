import 'package:nyx_converter/nyx_converter.dart';

abstract class INyxConverter {
  ///
  /// ### Parameters:
  /// - [filePath] (String): The path to the input media file.
  /// - [outputPath] (String): The desired path for the converted output file. (e.g., "/storage/emulated/0/Movies")
  /// - [container] (NyxContainer, optional): The target format for the converted file (e.g., "mp4", "avi").
  /// - [debug] (bool, optional): By setting this item to true, you can get more detailed logs of nyx_converter processes.
  /// - [fileName] (String, optional): change output file name.
  /// - [videoCodec] (NyxVideoCodec, optional): The desired video codec for the converted file (e.g., "h264", "vp8").
  /// - [audioCodec] (NyxAudioCodec, optional): The desired audio codec for the converted file (e.g., "aac", "mp3").
  /// - [size] (NyxSize, optional): The target width and height of the converted video in pixels.
  /// - [bitrate] (NyxBitrate, optional): The desired bitrate of the converted file in kilobits per second (kbps).
  /// - [frequency] (NyxFrequency, optional): The target sampling frequency of the converted audio stream in Hertz (Hz).
  /// - [channelLayout] (NyxChannelLayout, optional): The desired number of audio channels (1 for mono, 2 for stereo) in the converted file.
  ///
  /// ### Return Type:
  /// - [Future<NyxData>]: The function returns a [Future] that resolves to a [NyxData] object
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
  ///      videoCodec: NyxVideoCodec.h264,
  ///      audioCodec: NyxAudioCodec.flac,
  ///      size: NyxSize.w1280h720,
  ///      bitrate: NyxBitrate.k320,
  ///      frequency: NyxFrequency.hz48000,
  ///      channelLayout: NyxChannelLayout.stereo);
  /// ```
  ///
  Future<NyxData> convertTo(String filePath, String outputPath,
      {bool debugMode = false,
      String? fileName,
      NyxContainer? container,
      NyxVideoCodec? videoCodec,
      NyxAudioCodec? audioCodec,
      NyxSize? size,
      NyxBitrate? bitrate,
      NyxFrequency? frequency,
      NyxChannelLayout? channelLayout});
}
