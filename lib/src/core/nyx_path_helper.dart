import 'package:path/path.dart' as p;

import '../../nyx_converter.dart';

/// Utility methods for working with media file paths.
///
/// This class is responsible only for generating and extracting
/// file and directory information.
abstract final class NyxPathHelper {
  NyxPathHelper._();

  /// Builds the absolute output file path for the converted media.
  ///
  /// If [fileName] is omitted, the input file name is reused.
  /// If [container] is omitted, the input file extension is reused.
  ///
  /// Example:
  /// ```dart
  /// final path = NyxPathHelper.buildOutputPath(
  ///   inputPath: '/storage/emulated/0/DCIM/video.mov',
  ///   outputDirectory: '/storage/emulated/0/Movies',
  ///   fileName: 'holiday',
  ///   container: NyxContainer.mp4,
  /// );
  ///
  /// // /storage/emulated/0/Movies/holiday.mp4
  /// ```
  ///
  /// Returns the absolute path where the converted file will be written.
  static String buildOutputPath({
    required String inputPath,
    required String outputDirectory,
    String? fileName,
    NyxContainer? container,
  }) {
    final name = fileName ?? getFileBaseName(inputPath);

    final extension = container?.command ?? getFileContainer(inputPath);

    return getOutputFilePath(
      outputDirectory,
      name,
      extension,
    );
  }

  /// Returns the absolute output file path.
  ///
  /// Example:
  /// ```dart
  /// final path = NyxPathHelper.getOutputFilePath(
  ///   '/storage/emulated/0/Movies',
  ///   'holiday',
  ///   'mp4',
  /// );
  ///
  /// // /storage/emulated/0/Movies/holiday.mp4
  /// ```
  static String getOutputFilePath(
    String outputDirectory,
    String fileName,
    String container,
  ) {
    return '$outputDirectory/$fileName.$container';
  }

  /// Returns the file name without its extension.
  ///
  /// Example:
  /// `/storage/video/movie.mp4`
  ///
  /// becomes:
  ///
  /// `movie`
  static String getFileBaseName(String path) =>
      p.basenameWithoutExtension(path);

  /// Returns the file extension without the leading dot.
  ///
  /// Example:
  /// `/storage/video/movie.mp4`
  ///
  /// becomes:
  ///
  /// `mp4`
  static String getFileContainer(String path) =>
      p.extension(path).replaceFirst('.', '');
}
