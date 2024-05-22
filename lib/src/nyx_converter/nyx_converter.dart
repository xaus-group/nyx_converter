import 'package:nyx_converter/src/helper/nyx_audio_codec.dart';
import 'package:nyx_converter/src/helper/nyx_bitrate.dart';
import 'package:nyx_converter/src/helper/nyx_channel.dart';
import 'package:nyx_converter/src/helper/nyx_data.dart';
import 'package:nyx_converter/src/helper/nyx_container.dart';
import 'package:nyx_converter/src/helper/nyx_frequency.dart';
import 'package:nyx_converter/src/helper/nyx_size.dart';
import 'package:nyx_converter/src/helper/nyx_video_codec.dart';

abstract class INyxConverter {
  ///
  /// ### Parameters:
  /// - [filePath] (String): The path to the input media file.
  /// - [outputPath] (String): The desired path for the converted output file.
  /// - [container] (NyxContainer, optional): The target format for the converted file (e.g., "mp4", "avi").
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
  ///      container: NyxContainer.mp4,
  ///      videoCodec: NyxVideoCodec.h264,
  ///      audioCodec: NyxAudioCodec.flac,
  ///      size: NyxSize.w1280h720,
  ///      bitrate: NyxBitrate.k320,
  ///      frequency: NyxFrequency.hz48000,
  ///      channelLayout: NyxChannelLayout.stereo);
  /// ```
  ///
  Future<NyxData> convertTo(String filePath, String outputPath,
      {NyxContainer container,
      NyxVideoCodec videoCodec,
      NyxAudioCodec audioCodec,
      NyxSize size,
      NyxBitrate bitrate,
      NyxFrequency frequency,
      NyxChannelLayout channelLayout});
}

class _NyxConverter extends INyxConverter {
  static _NyxConverter? _ins;

  _NyxConverter._internal() {
    _ins = this;
  }

  factory _NyxConverter() => _ins ?? _NyxConverter._internal();

  @override
  Future<NyxData> convertTo(filePath, outputPath,
      {NyxContainer? container,
      NyxVideoCodec? videoCodec,
      NyxAudioCodec? audioCodec,
      NyxSize? size,
      NyxBitrate? bitrate,
      NyxFrequency? frequency,
      NyxChannelLayout? channelLayout}) {
    // TODO: implement convertTo
    throw UnimplementedError();
  }
}

/// Nyx Converter.
///
/// Method in the static class will help you to convert media files,
///
/// You can use `NyxConverter.convertTo` to convert media files
///
// ignore: non_constant_identifier_names
INyxConverter get NyxConverter => _NyxConverter();
