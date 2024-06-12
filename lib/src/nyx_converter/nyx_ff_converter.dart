import 'dart:developer';

import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/log.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/session.dart';
import 'package:nyx_converter/nyx_converter.dart';
import 'package:nyx_converter/src/helper/nyx_status.dart';

class NyxFFConverter {
  static NyxFFConverter? _ins;

  NyxFFConverter._internal() {
    _ins = this;
  }

  factory NyxFFConverter() => _ins ?? NyxFFConverter._internal();

  Future<NyxData> execute(
      String command, bool debugMode, String outputFilePath) {
    return FFmpegKit.executeAsync(command, (Session session) async {
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode) == true) {
      } else if (ReturnCode.isSuccess(returnCode) == false) {
        throw Exception("[nyx_converter] A problem has occurred");
      } else {
        throw Exception("[nyx_converter] A problem has occurred");
      }
    }, (Log ffmpegLog) {
      // print log messages
      debugMode ? log('[nyx_converter] ${ffmpegLog.getMessage()}') : '';
    }).then((session) async {
      // print log FailStackTrace
      debugMode
          ? log('[nyx_converter] ${await session.getFailStackTrace()}')
          : '';
      // print all logs
      debugMode
          ? log('[nyx_converter] ${await session.getAllLogsAsString()}')
          : '';

      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        return NyxData(outputFilePath, NyxStatus.success);
      } else if (ReturnCode.isCancel(returnCode)) {
        return const NyxData('', NyxStatus.cancel,
            message: 'Processes have been cancelled');
      } else {
        return const NyxData('', NyxStatus.error,
            message: 'A problem has occurred');
      }
    }).onError((error, stackTrace) {
      throw Exception("[nyx_converter] $error");
    });
  }
}
