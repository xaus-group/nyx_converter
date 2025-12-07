import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:nyx_converter/nyx_converter.dart';
import 'package:nyx_converter/src/helper/verify_data.dart';
import 'package:path/path.dart';

class NyxHelper {
  static NyxHelper? _ins;

  NyxHelper._internal() {
    _ins = this;
  }

  factory NyxHelper() => _ins ?? NyxHelper._internal();

  // check all input data
  VerifyData verifyData(
    String filePath,
    String outputPath,
    String cntinr, {
    String? fileName,
  }) {
    // Check input file
    if (!File(filePath).existsSync()) {
      log('[Error] [nyx_converter] The imported file does not exist.');
      return VerifyData(NyxStatus.failed,
          message: 'The imported file does not exist.');
    }
    // Check output directory existance
    else if (!Directory(outputPath).existsSync()) {
      log('[Error] [nyx_converter] The directory entered does not exist.');
      return VerifyData(NyxStatus.failed,
          message: 'The directory entered does not exist.');
    }
    // Check output file existance
    else if (File(
            '$outputPath/${fileName ?? getFileBaseName(filePath)}.$cntinr')
        .existsSync()) {
      log('[Error] [nyx_converter] The output file already exists please change the file name');
      return VerifyData(NyxStatus.failed,
          message:
              'The output file already exists please change the file name');
    }
    // check input file have container or not
    else if (getFileContainer(filePath).isEmpty) {
      log('[Error] [nyx_converter] The imported file does not have the specified container');
      return VerifyData(NyxStatus.failed,
          message: 'The imported file does not have the specified container');
    }
    // verify input file name
    else if (fileName != null && !verifyFileName(fileName)) {
      log('[Error] [nyx_converter] The file name must not contain the character "|\\?*<\":>+[]/\'".');
      return VerifyData(NyxStatus.failed,
          message:
              'The file name must not contain the character "|\\?*<\":>+[]/\'".');
    } else {
      return VerifyData(
        NyxStatus.success,
      );
    }
  }

  String getCommand(
    String filePath,
    String outputFilePath, // storage/emulated/0/Movies/name123.mp4
    {
    NyxVideoCodec? videoCodec,
    NyxAudioCodec? audioCodec,
    // NyxSize? size,
    int? audioBitrate,
    int? videoBitrate,
    // NyxFrequency? frequency,
    // NyxChannelLayout? channelLayout
  }) {
    String command = "";
    command += """-i "$filePath" """;

    if (videoCodec != null) {
      command += "-c:v ${videoCodec.command} ";
    }

    if (videoBitrate != null) {
      // sets the video bitrate to 5Mbps, 10Mbps, ...
      command += "-b:v ${videoBitrate}M ";
    }

    if (audioCodec != null) {
      command += "-c:a ${audioCodec.command} ";
    }

    if (audioBitrate != null) {
      // sets the audio bitrate to 320kbps, 256kbps, ...
      command += "-b:a ${audioBitrate}k ";
    }

    // if (frequency != null) {
    //   // sets the audio sample rate to 48000Hz,...
    //   command += "-ar ${frequency.command} ";
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
  String getFileBaseName(String filePath) => basenameWithoutExtension(filePath);

  // return => /storage/emulated/0/Movies/name123.mp4
  String getOutPutFilePath(String outputPath, String fileName,
          String container) => // outputPath: /storage/emulated/0/Movies,
      // fileName: name123
      // container: mp4
      // => /storage/emulated/0/Movies/name123.mp4
      "$outputPath/$fileName.$container";

  String getFileContainer(String filePath) => extension(filePath);

  bool verifyFileName(String fileName) {
    final unwantedCharsRegex = RegExp(r'[|\\?\<\":\+\[\]\/]');
    return !unwantedCharsRegex.hasMatch(fileName);
  }

  Future<double?> getVideoDuration(String path) async {
    final session = await FFprobeKit.getMediaInformation(path);
    final info = session.getMediaInformation();
    if (info == null) return null;

    final duration = info.getDuration();
    return double.tryParse(duration ?? "");
  }

  /// Parses HH:MM:SS.xx or MM:SS.xx or SS.xx
  double _parseTime(String t) {
    final parts = t.split(':');
    if (parts.length == 3) {
      return Duration(
            hours: int.parse(parts[0]),
            minutes: int.parse(parts[1]),
            seconds: double.parse(parts[2]).floor(),
          ).inSeconds.toDouble() +
          (double.parse(parts[2]) % 1);
    }
    if (parts.length == 2) {
      return Duration(
        minutes: int.parse(parts[0]),
        seconds: int.parse(parts[1].split('.').first),
      ).inSeconds.toDouble();
    }
    return double.tryParse(t) ?? 0;
  }

  /// EXTRACT PERCENT FROM LOG
  double? getPercent(String msg, double? totalDuration) {
    if (totalDuration == null) return null;

    final match = RegExp(r'time=([\d\.:]+)').firstMatch(msg);
    if (match == null) return null;

    final timeString = match.group(1)!;
    final seconds = _parseTime(timeString);

    return (seconds / totalDuration * 100).clamp(0, 100);
  }

  /// EXTRACT FPS FROM LOG
  double? getFps(String msg) {
    final match = RegExp(r'fps=\s*([\d\.]+)').firstMatch(msg);
    if (match == null) return null;

    return double.tryParse(match.group(1)!);
  }

  /// EXTRACT SPEED FROM LOG
  double? getSpeed(String msg) {
    final match = RegExp(r'speed=\s*([\d\.]+)x').firstMatch(msg);
    if (match == null) return null;

    return double.tryParse(match.group(1)!);
  }
}
