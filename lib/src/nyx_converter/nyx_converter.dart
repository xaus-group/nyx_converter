import 'dart:developer';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/session.dart';
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
  /// - [outputPath] (String): The desired path for the converted output file. (e.g., "/storage/emulated/0/Movies")
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
  ///      NyxContainer.mp4,
  ///      videoCodec: NyxVideoCodec.h264,
  ///      audioCodec: NyxAudioCodec.flac,
  ///      size: NyxSize.w1280h720,
  ///      bitrate: NyxBitrate.k320,
  ///      frequency: NyxFrequency.hz48000,
  ///      channelLayout: NyxChannelLayout.stereo);
  /// ```
  ///
  Future<NyxData> convertTo(
      String filePath, String outputPath, NyxContainer container,
      {NyxVideoCodec videoCodec,
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
  Future<NyxData> convertTo(filePath, outputPath, NyxContainer container,
      {NyxVideoCodec? videoCodec,
      NyxAudioCodec? audioCodec,
      NyxSize? size,
      NyxBitrate? bitrate,
      NyxFrequency? frequency,
      NyxChannelLayout? channelLayout}) {
    return FFmpegKit.executeAsync(
            _getCommand(
                filePath,
                _getOutPutFilePath(
                    outputPath, _getFileName(filePath), container),
                container), (Session session) async {
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode) == true) {
        //TODO Success
      } else if (ReturnCode.isSuccess(returnCode) == false) {
        //TODO Cancel
      } else {
        //TODO Error
      }
    }, (Log log) {})
        .then((session) async {
      // Console output generated for this execution
      // final output = await session.getOutput();
      // The stack trace if FFmpegKit fails to run a command
      // final failStackTrace = await session.getFailStackTrace();
      // await session.getAllLogsAsString()
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        return NyxData(
            _getOutPutFilePath(outputPath, _getFileName(filePath), container));
      } else if (ReturnCode.isCancel(returnCode)) {
        //TODO: Cancel
        return NyxData('');
      } else {
        //TODO: Error
        return NyxData('');
      }
    }).onError((error, stackTrace) {
      log("[Error] [nyx_converter] $error");
      return const NyxData('');
    });
  }

  String _getCommand(
    String filePath,
    String outputFilePath,
    NyxContainer container,
    //TODO: {
    // NyxVideoCodec? videoCodec,
    // NyxAudioCodec? audioCodec,
    // NyxSize? size,
    // NyxBitrate? bitrate,
    // NyxFrequency? frequency,
    // NyxChannelLayout? channelLayout
    // }
  ) {
    String command = "";
    command += "-i '$filePath' -vcodec copy -acodec copy ";

    //TODO:
    //if (videoCodec != null) {
    //   command += "-c:v ${videoCodec.command} ";
    // }
    // if (audioCodec != null) {
    //   // sets the audio codec (MP3=>libmp3lame, AAC=>libfdk_aac, ...)
    //   command += "-c:a ${audioCodec.command} ";
    // }
    // if (frequency != null) {
    //   // sets the audio sample rate to 48000Hz,...
    //   command += "-ar ${frequency.command} ";
    // }
    // if (bitrate != null) {
    //   // sets the audio bitrate to 320kbps, 256kbps, ...
    //   command += "-b:a ${bitrate.command} ";
    // }
    // if (channelLayout != null) {
    //   if (channelLayout.title == 'Stereo') {
    //     // sets the audio channels to stereo
    //     command += "-ac 2 ";
    //   }
    //   if (channelLayout.title == 'Mono') {
    //     // sets the audio channels to mono
    //     command += "-ac 1 ";
    //   }
    // }
    // if (size != null) {
    //   command += "-s $size ";
    // }

    command += "'$outputFilePath'";

    return command;
  }

  String _getFileName(String filePath) =>
      filePath.split('/').last.split('.').first;

  String _getOutPutFilePath(String outputPath, String fileName,
          NyxContainer container) => // outputPath: /storage/emulated/0/Movies,
      // fileName: name123
      // container: mp4
      // => /storage/emulated/0/Movies/name123.mp4
      "$outputPath/$fileName.${container.command}";
}

/// Nyx Converter.
///
/// Method in the static class will help you to convert media files,
///
/// You can use `NyxConverter.convertTo` to convert media files
///
// ignore: non_constant_identifier_names
INyxConverter get NyxConverter => _NyxConverter();
