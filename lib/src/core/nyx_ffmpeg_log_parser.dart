abstract final class NyxFFMPEGLogParser {
  NyxFFMPEGLogParser._();

  /// Extracts the conversion progress percentage from an FFmpeg log line.
  ///
  /// Returns `null` until enough information is available.
  static double? getProgress(
    String logLine,
    double? totalDuration,
  ) {
    if (totalDuration == null) {
      return null;
    }

    final match = RegExp(r'time=(\d+):(\d+):(\d+\.\d+)').firstMatch(logLine);

    if (match == null) {
      return null;
    }

    final hours = int.parse(match.group(1)!);
    final minutes = int.parse(match.group(2)!);
    final seconds = double.parse(match.group(3)!);

    final current = hours * 3600 + minutes * 60 + seconds;

    return (current / totalDuration * 100).clamp(0, 100);
  }

  /// Extracts the current FPS from an FFmpeg log line.
  ///
  /// Returns `null` when unavailable.
  static double? getFps(String logLine) {
    final match = RegExp(r'fps=\s*([\d.]+)').firstMatch(logLine);

    return match == null ? null : double.tryParse(match.group(1)!);
  }

  /// Extracts the current conversion speed from an FFmpeg log line.
  ///
  /// Example values:
  /// - 0.75
  /// - 1.00
  /// - 2.31
  ///
  /// Returns `null` when unavailable.
  static double? getSpeed(String logLine) {
    final match = RegExp(r'speed=\s*([\d.]+)x').firstMatch(logLine);

    return match == null ? null : double.tryParse(match.group(1)!);
  }
}
