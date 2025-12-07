import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/log.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:ffmpeg_kit_flutter_new/session.dart';
import 'package:ffmpeg_kit_flutter_new/session_state.dart';
import 'package:nyx_converter/nyx_converter.dart';
import 'package:nyx_converter/src/nyx_converter/nyx_helper.dart';

class NyxFFConverter {
  static NyxFFConverter? _ins;
  NyxFFConverter._internal() {
    _ins = this;
  }
  factory NyxFFConverter() => _ins ?? NyxFFConverter._internal();

  execute({
    required String inputPath,
    required String command,
    required bool debugMode,
    required String outputFilePath,
    required Function(int id) sessionId,
    required Function(
      NyxStatus status, {
      double? progress,
      double? fps,
      double? speed,
      String? errorMessage,
    }) execution,
  }) async {
    final totalDuration = await NyxHelper().getVideoDuration(inputPath);

    return FFmpegKit.executeAsync(
      command,

      /// Final callback
      (Session session) async {
        final returnCode = await session.getReturnCode();

        if (ReturnCode.isCancel(returnCode)) {
          execution(NyxStatus.cancel);
          return;
        }

        final state = await session.getState();

        if (state == SessionState.completed) {
          if (!File(outputFilePath).existsSync()) {
            execution(NyxStatus.failed, errorMessage: 'Unexpected Error!');
          } else {
            execution(NyxStatus.completed, progress: 100);
          }
        } else {
          execution(NyxStatus.failed, errorMessage: "A problem has occurred");
        }
      },

      /// LOG CALLBACK — fires during running
      (Log logLine) {
        final msg = logLine.getMessage();
        if (debugMode) log("[nyx_converter] $msg");

        final percent = NyxHelper().getPercent(msg, totalDuration);
        final fps = NyxHelper().getFps(msg);
        final speed = NyxHelper().getSpeed(msg);

        // If nothing readable yet — skip
        if (percent == null && fps == null && speed == null) return;

        execution(
          NyxStatus.running,
          progress: percent,
          fps: fps,
          speed: speed,
        );
      },
    ).then((session) {
      sessionId(session.getSessionId() ?? 0);
    }).onError((e, s) {
      execution(NyxStatus.failed, errorMessage: e.toString());
    });
  }
}
