import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:path/path.dart' as p;
import 'package:nyx_converter/nyx_converter.dart';
import 'package:nyx_converter/src/models/verify_data.dart';

import '../models/nyx_verify_error.dart';

class NyxHelpe {
  static NyxHelpe? _ins;

  NyxHelpe._internal() {
    _ins = this;
  }

  factory NyxHelpe() => _ins ?? NyxHelpe._internal();

  /// Forbidden characters across Windows, Linux, and macOS.
  static const String _forbiddenChars = r'[<>:"/\\|?*]';
  static final RegExp _forbiddenRegex = RegExp(_forbiddenChars);
  static final RegExp _controlCharsRegex = RegExp(r'[\x00-\x1f\x7f]');

  Future<VerifyData> validate({
    required String inputPath,
    required String outputFilePath,
  }) async {
    final outputResult = _verifyOutputFile(outputFilePath);

    if (outputResult != null) {
      return outputResult;
    }

    final inputResult = await _verifyInputFile(inputPath);

    if (inputResult != null) {
      return inputResult;
    }

    return const VerifyData.success();
  }

  Future<VerifyData?> _verifyInputFile(String inputPath) async {
    final file = File(inputPath);

    if (!file.existsSync()) {
      return _fail(NyxVerifyError.inputFileNotFound);
    }

    if (FileSystemEntity.typeSync(inputPath) != FileSystemEntityType.file) {
      return _fail(NyxVerifyError.inputIsNotFile);
    }

    if (file.lengthSync() == 0) {
      return _fail(NyxVerifyError.inputFileEmpty);
    }

    try {
      file.openSync().closeSync();
    } catch (_) {
      return _fail(NyxVerifyError.inputFileUnreadable);
    }

    final session = await FFprobeKit.getMediaInformation(inputPath);
    final info = session.getMediaInformation();

    if (info == null) {
      return _fail(
        NyxVerifyError.inputMediaInvalid,
      );
    }

    final streams = info.getStreams();

    if (streams.isEmpty) {
      return _fail(NyxVerifyError.inputMediaInvalid);
    }

    return null;
  }

  VerifyData? _verifyOutputFile(String outputFilePath) {
    final file = File(outputFilePath);

    if (!file.parent.existsSync()) {
      return _fail(
        NyxVerifyError.outputDirectoryNotFound,
      );
    }

    final fileName = p.basenameWithoutExtension(outputFilePath);
    final sanitized = _sanitizeFileName(fileName);

    if (sanitized.isEmpty) {
      return _fail(
        NyxVerifyError.outputFileNameInvalid,
      );
    }

    if (sanitized != fileName) {
      return _fail(
        NyxVerifyError.outputFileNameInvalid,
      );
    }

    if (file.existsSync()) {
      return _fail(
        NyxVerifyError.outputFileAlreadyExists,
      );
    }

    return null;
  }

  String _sanitizeFileName(String name) {
    String sanitized =
        name.replaceAll(_forbiddenRegex, '').replaceAll(_controlCharsRegex, '');
    return sanitized.trim().replaceAll(RegExp(r'^\.+|\.+$'), '');
  }

  VerifyData _fail(NyxVerifyError error) {
    log('[Error] [nyx_converter] ${error.message}');
    return VerifyData.failed(
      error,
      message: error.message,
    );
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
  String getFileBaseName(String filePath) =>
      p.basenameWithoutExtension(filePath);

  // return => /storage/emulated/0/Movies/name123.mp4
  String getOutPutFilePath(String outputPath, String fileName,
          String container) => // outputPath: /storage/emulated/0/Movies,
      // fileName: name123
      // container: mp4
      // => /storage/emulated/0/Movies/name123.mp4
      "$outputPath/$fileName.$container";

  String getFileContainer(String filePath) => p.extension(filePath);

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
