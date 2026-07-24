import 'dart:io';

import 'package:path/path.dart' as p;

import '../models/nyx_verify_error.dart';
import '../models/verify_data.dart';
import 'nyx_media_probe.dart';

abstract final class NyxValidator {
  NyxValidator._();

  static const _forbiddenChars = r'[<>:"/\\|?*]';

  static final _forbiddenRegex = RegExp(_forbiddenChars);

  static final _controlRegex = RegExp(r'[\x00-\x1f\x7f]');

  /// Validates both the input media and output destination.
  ///
  /// Validation stops immediately after the first failure.
  static Future<VerifyData> validate({
    required String inputPath,
    required String outputFilePath,
  }) async {
    final input = await _validateInput(inputPath);

    if (input != null) {
      return input;
    }

    final output = _validateOutput(outputFilePath);

    if (output != null) {
      return output;
    }

    return const VerifyData.success();
  }

  /// Validates the input media file.
  static Future<VerifyData?> _validateInput(
    String inputPath,
  ) async {
    final file = File(inputPath);

    if (!file.existsSync()) {
      return _fail(
        NyxVerifyError.inputFileNotFound,
        'Input file does not exist.',
      );
    }

    if (FileSystemEntity.typeSync(inputPath) != FileSystemEntityType.file) {
      return _fail(
        NyxVerifyError.inputIsNotFile,
        'Input path is not a file.',
      );
    }

    if (file.lengthSync() == 0) {
      return _fail(
        NyxVerifyError.inputFileEmpty,
        'Input file is empty.',
      );
    }

    try {
      file.openSync().closeSync();
    } catch (_) {
      return _fail(
        NyxVerifyError.inputFileUnreadable,
        'Unable to read the input file.',
      );
    }

    if (!await NyxMediaProbe.isValidMedia(inputPath)) {
      return _fail(
        NyxVerifyError.inputMediaInvalid,
        'Unsupported or corrupted media file.',
      );
    }

    return null;
  }

  /// Validates the output location and file name.
  static VerifyData? _validateOutput(
    String outputFilePath,
  ) {
    final file = File(outputFilePath);

    if (!file.parent.existsSync()) {
      return _fail(
        NyxVerifyError.outputDirectoryNotFound,
        'Output directory does not exist.',
      );
    }

    final fileName = p.basenameWithoutExtension(outputFilePath);

    final sanitized = fileName
        .replaceAll(_forbiddenRegex, '')
        .replaceAll(_controlRegex, '')
        .trim()
        .replaceAll(RegExp(r'^\.+|\.+$'), '');

    if (sanitized.isEmpty) {
      return _fail(
        NyxVerifyError.outputFileNameInvalid,
        'Invalid output file name.',
      );
    }

    if (sanitized != fileName) {
      return _fail(
        NyxVerifyError.outputFileNameInvalid,
        'Output file name contains invalid characters.',
      );
    }

    if (file.existsSync()) {
      return _fail(
        NyxVerifyError.outputFileAlreadyExists,
        'Output file already exists.',
      );
    }

    return null;
  }

  static VerifyData _fail(
    NyxVerifyError error,
    String message,
  ) {
    return VerifyData.failed(
      error,
      message: message,
    );
  }
}
