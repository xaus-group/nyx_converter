import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/log.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:ffmpeg_kit_flutter_new/session.dart';
import 'package:ffmpeg_kit_flutter_new/session_state.dart';
import 'package:nyx_converter/nyx_converter.dart';

import '../callbacks/nyx_session_callback.dart';
import '../core/nyx_ffmpeg_log_parser.dart';
import '../core/nyx_media_probe.dart';

/// Executes FFmpeg commands and reports conversion progress.
///
/// This class is stateless and acts as a thin wrapper around
/// `ffmpeg_kit_flutter`.
abstract final class NyxFFConverter {
  /// Starts an asynchronous FFmpeg conversion.
  ///
  /// Progress updates are delivered through [execution].
  /// The created FFmpeg session id is returned through [sessionId].
  static Future<void> execute({
    required String inputPath,
    required String command,
    required bool debugMode,
    required String outputFilePath,
    required NyxSessionCallback sessionId,
    NyxConvertionCallback? execution,
  }) async {
    final completer = Completer<void>();

    final duration = await NyxMediaProbe.getDuration(inputPath);

    try {
      final session = await FFmpegKit.executeAsync(
        command,
        (session) => _handleCompleted(
          session,
          outputFilePath,
          execution,
          completer,
        ),
        (log) => _handleLog(
          log,
          duration,
          debugMode,
          execution,
        ),
      );

      sessionId(session.getSessionId() ?? 0);

      return completer.future;
    } catch (e) {
      if (!completer.isCompleted) {
        completer.completeError(e);
      }

      _notifyFailure(
        execution,
        e.toString(),
      );

      return completer.future;
    }
  }

  /// Handles the final FFmpeg session result.
  static Future<void> _handleCompleted(
    Session session,
    String outputFilePath,
    NyxConvertionCallback? execution,
    Completer<void> completer,
  ) async {
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isCancel(returnCode)) {
      execution?.call(NyxStatus.cancel);

      if (!completer.isCompleted) {
        completer.completeError(
          Exception('Conversion cancelled.'),
        );
      }

      return;
    }

    if (await session.getState() != SessionState.completed) {
      const message = 'FFmpeg did not complete successfully.';

      _notifyFailure(
        execution,
        message,
      );

      if (!completer.isCompleted) {
        completer.completeError(
          Exception(message),
        );
      }

      return;
    }

    if (!File(outputFilePath).existsSync()) {
      const message = 'Output file was not created.';

      _notifyFailure(
        execution,
        message,
      );

      if (!completer.isCompleted) {
        completer.completeError(
          Exception(message),
        );
      }

      return;
    }

    execution?.call(
      NyxStatus.completed,
      progress: 100,
    );

    if (!completer.isCompleted) {
      completer.complete();
    }
  }

  /// Parses FFmpeg log output and reports conversion progress.
  static void _handleLog(
    Log log,
    double? duration,
    bool debugMode,
    NyxConvertionCallback? execution,
  ) {
    final message = log.getMessage();

    if (debugMode) {
      developer.log(
        '[nyx_converter] $message',
      );
    }

    final progress = NyxFFMPEGLogParser.getProgress(message, duration);

    final fps = NyxFFMPEGLogParser.getFps(message);

    final speed = NyxFFMPEGLogParser.getSpeed(message);

    if (progress == null && fps == null && speed == null) {
      return;
    }

    execution?.call(
      NyxStatus.running,
      progress: progress,
      fps: fps,
      speed: speed,
    );
  }

  /// Reports a conversion failure.
  static void _notifyFailure(
    NyxConvertionCallback? execution,
    String message,
  ) {
    execution?.call(
      NyxStatus.failed,
      errorMessage: message,
    );
  }
}
