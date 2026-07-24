import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:nyx_converter/nyx_converter.dart';
import 'package:nyx_converter/src/nyx_converter/i_nyx_converter.dart';
import 'package:nyx_converter/src/nyx_converter/nyx_ff_converter.dart';

import '../core/nyx_command_builder.dart';
import '../core/nyx_path_helper.dart';
import '../core/nyx_validator.dart';

class _NyxConverter extends INyxConverter {
  static final _NyxConverter _instance = _NyxConverter._internal();

  _NyxConverter._internal();

  factory _NyxConverter() => _instance;

  final Set<int> _sessionIds = {};

  @override
  Future<void> convertTo(
    String inputPath,
    String outputDirectory, {
    bool debugMode = false,
    String? fileName,
    NyxContainer? container,
    NyxVideoCodec? videoCodec,
    NyxAudioCodec? audioCodec,
    int? audioBitrate,
    int? videoBitrate,
    NyxConvertionCallback? execution,
  }) async {
    final outputFilePath = NyxPathHelper.buildOutputPath(
      inputPath: inputPath,
      outputDirectory: outputDirectory,
      fileName: fileName,
      container: container,
    );

    final result = await NyxValidator.validate(
      inputPath: inputPath,
      outputFilePath: outputFilePath,
    );

    if (!result.isSuccess) {
      execution?.call(
        NyxStatus.failed,
        errorMessage: result.message,
      );
      return;
    }

    final command = NyxCommandBuilder.build(
      inputPath: inputPath,
      outputFilePath: outputFilePath,
      videoCodec: videoCodec,
      audioCodec: audioCodec,
      audioBitrate: audioBitrate,
      videoBitrate: videoBitrate,
    );

    await NyxFFConverter.execute(
      inputPath: inputPath,
      command: command,
      debugMode: debugMode,
      outputFilePath: outputFilePath,
      sessionId: _sessionIds.add,
      execution: execution,
    );
  }

  @override
  void kill() {
    for (final sessionId in _sessionIds) {
      FFmpegKit.cancel(sessionId);
    }

    _sessionIds.clear();
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
