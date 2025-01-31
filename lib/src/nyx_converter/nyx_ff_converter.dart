import 'dart:developer';

import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/log.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/session_state.dart';
import 'package:nyx_converter/nyx_converter.dart';

class NyxFFConverter {
  static NyxFFConverter? _ins;

  NyxFFConverter._internal() {
    _ins = this;
  }

  factory NyxFFConverter() => _ins ?? NyxFFConverter._internal();

  execute(
      {required Function(int? sId) sessionId,
      required String command,
      required bool debugMode,
      required String outputFilePath,
      required Function(String? path, NyxStatus status, {String? errorMessage})
          execution}) {
    return FFmpegKit.executeAsync(command, (Session session) async {
      final returnCode = await session.getReturnCode();

      // check completion of process
      if (ReturnCode.isCancel(returnCode)) {
        execution(null, NyxStatus.cancel);
      } else {
        SessionState state = await session.getState();

        switch (state) {
          case SessionState.running:
            execution(null, NyxStatus.running);

            break;
          case SessionState.failed:
            execution(null, NyxStatus.failed,
                errorMessage: 'A problem has occurred');
            break;
          case SessionState.completed:
            execution(outputFilePath, NyxStatus.completed);

            break;
          default:
            execution(null, NyxStatus.failed,
                errorMessage: 'A problem has occurred');
        }
      }
    }, (Log ffmpegLog) {
      // print log messages
      debugMode ? log('[nyx_converter] ${ffmpegLog.getMessage()}') : '';
    }).then((session) async {
      sessionId(session.getSessionId());

      // print log FailStackTrace
      debugMode
          ? log('[nyx_converter] ${await session.getFailStackTrace()}')
          : '';
      // print all logs
      debugMode
          ? log('[nyx_converter] ${await session.getAllLogsAsString()}')
          : '';

      final returnCode = await session.getReturnCode();

      // check completion of process
      if (ReturnCode.isCancel(returnCode)) {
        execution(null, NyxStatus.cancel);
      } else {
        SessionState state = await session.getState();

        switch (state) {
          case SessionState.running:
            execution(null, NyxStatus.running);

            break;
          case SessionState.failed:
            execution(null, NyxStatus.failed,
                errorMessage: 'A problem has occurred');
            break;
          case SessionState.completed:
            execution(outputFilePath, NyxStatus.completed);

            break;
          default:
            execution(null, NyxStatus.failed,
                errorMessage: 'A problem has occurred');
        }
      }
    }).onError((error, stackTrace) {
      throw Exception("$error");
    });
  }
}
