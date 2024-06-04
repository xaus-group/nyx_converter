import 'dart:developer';
import 'dart:io';

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
import 'package:nyx_converter/src/helper/nyx_status.dart';
import 'package:nyx_converter/src/helper/nyx_video_codec.dart';

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
  Future<NyxData> convertTo(
      String filePath, String outputPath, NyxContainer container,
      {bool debugMode = false,
      String? fileName,
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
  Future<NyxData> convertTo(filePath, outputPath, NyxContainer container,
      {bool debugMode = false,
      String? fileName,
      NyxVideoCodec? videoCodec,
      NyxAudioCodec? audioCodec,
      NyxSize? size,
      NyxBitrate? bitrate,
      NyxFrequency? frequency,
      NyxChannelLayout? channelLayout}) async {
    // Check input file name
    if (fileName != null &&
        (fileName.contains('.') || fileName.contains('/'))) {
      log('[Error] [nyx_converter] The file name must not contain the character "." and be "/".');
      return const NyxData('', NyxStatus.error,
          message:
              'The file name must not contain the character "." and be "/".');
    }
    // Check output file existance
    else if (File(
            '$outputPath/${fileName ?? _getFileName(filePath)}.${container.command}')
        .existsSync()) {
      log('[Error] [nyx_converter] The output file already exists please change the file name');
      return const NyxData('', NyxStatus.error,
          message: 'The output file already exists');
    } else {
      return FFmpegKit.executeAsync(
          _getCommand(
              filePath,
              _getOutPutFilePath(
                  outputPath, fileName ?? _getFileName(filePath), container),
              container), (Session session) async {
        final returnCode = await session.getReturnCode();
        if (ReturnCode.isSuccess(returnCode) == true) {
        } else if (ReturnCode.isSuccess(returnCode) == false) {
          log("[Error] [nyx_converter] A problem has occurred");
        } else {
          log("[Error] [nyx_converter] A problem has occurred");
        }
      }, (Log ffmpegLog) {
        // print log messages
        debugMode ? log('[Log] [nyx_converter] ${ffmpegLog.getMessage()}') : '';
      }).then((session) async {
        // print log FailStackTrace
        debugMode
            ? log('[Log] [nyx_converter] ${await session.getFailStackTrace()}')
            : '';
        // print all logs
        debugMode
            ? log('[Log] [nyx_converter] ${await session.getAllLogsAsString()}')
            : '';

        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          return NyxData(
              _getOutPutFilePath(
                  outputPath, fileName ?? _getFileName(filePath), container),
              NyxStatus.success);
        } else if (ReturnCode.isCancel(returnCode)) {
          return const NyxData('', NyxStatus.cancel,
              message: 'Processes have been cancelled');
        } else {
          return const NyxData('', NyxStatus.error,
              message: 'A problem has occurred');
        }
      }).onError((error, stackTrace) {
        log("[Error] [nyx_converter] $error");
        return NyxData('', NyxStatus.error, message: error.toString());
      });
    }
  }

  String _getCommand(
    String filePath,
    String outputFilePath,
    NyxContainer container,
    //TODO: {NyxVideoCodec? videoCodec,
    // NyxAudioCodec? audioCodec,
    // NyxSize? size,
    // NyxBitrate? bitrate,
    // NyxFrequency? frequency,
    // NyxChannelLayout? channelLayout}
  ) {
    String command = "";
    command += "-i '$filePath' -vcodec copy -acodec copy ";

    //TODO if (videoCodec != null) {
    //   command += "-c:v ${videoCodec.command} ";
    // } else {
    //   command += '-vcodec copy';
    // }
    // if (audioCodec != null) {
    //   // sets the audio codec (MP3=>libmp3lame, AAC=>libfdk_aac, ...)
    //   command += "-c:a ${audioCodec.command} ";
    // } else {
    //   command += '-acodec copy';
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

  // return => 123name
  String _getFileName(String filePath) =>
      filePath.split('/').last.split('.').first;

  // return => /storage/emulated/0/Movies/name123.mp4
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
