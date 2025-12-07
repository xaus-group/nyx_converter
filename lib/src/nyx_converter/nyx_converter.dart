import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:nyx_converter/nyx_converter.dart';
import 'package:nyx_converter/src/helper/verify_data.dart';
import 'package:nyx_converter/src/nyx_converter/i_nyx_converter.dart';
import 'package:nyx_converter/src/nyx_converter/nyx_ff_converter.dart';
import 'package:nyx_converter/src/nyx_converter/nyx_helper.dart';

class _NyxConverter extends INyxConverter {
  static _NyxConverter? _ins;

  _NyxConverter._internal() {
    _ins = this;
  }

  factory _NyxConverter() => _ins ?? _NyxConverter._internal();

  final List<int?> sessionIds = [];

  @override
  convertTo(filePath, outputPath,
      {bool debugMode = false,
      String? fileName,
      NyxContainer? container,
      NyxVideoCodec? videoCodec,
      NyxAudioCodec? audioCodec,
      NyxSize? size,
      int? audioBitrate,
      int? videoBitrate,
      NyxFrequency? frequency,
      NyxChannelLayout? channelLayout,
      Function(NyxStatus status,
              {double? progress,
              double? fps,
              double? speed,
              String? errorMessage})?
          execution}) async {
    VerifyData verifyData = NyxHelper().verifyData(filePath, outputPath,
        container?.command ?? NyxHelper().getFileContainer(filePath),
        fileName: fileName);

    // if filePath, outputPath, fileName are verified or not
    if (verifyData.status == NyxStatus.success) {
      NyxFFConverter().execute(
        inputPath: filePath,
        sessionId: (sessionId) {
          if (!sessionIds.contains(sessionId)) {
            sessionIds.add(sessionId);
          }
        },
        command: NyxHelper().getCommand(
            filePath,
            NyxHelper().getOutPutFilePath(
                outputPath,
                fileName ?? NyxHelper().getFileBaseName(filePath),
                container?.command ?? NyxHelper().getFileContainer(filePath)),
            videoCodec: videoCodec,
            audioCodec: audioCodec,
            audioBitrate: audioBitrate,
            videoBitrate: videoBitrate),
        debugMode: debugMode,
        outputFilePath: NyxHelper().getOutPutFilePath(
            outputPath,
            fileName ?? NyxHelper().getFileBaseName(filePath),
            container?.command ?? NyxHelper().getFileContainer(filePath)),
        execution: (NyxStatus status, {errorMessage, fps, progress, speed}) {
          execution!(
            status,
            errorMessage: errorMessage,
            progress: progress,
            fps: fps,
            speed: speed,
          );
        },
      );
    } else {
      execution!(verifyData.status, errorMessage: verifyData.message);
    }
  }

  @override
  kill() {
    for (var sessionId in sessionIds) {
      FFmpegKit.cancel(sessionId!);
    }
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
