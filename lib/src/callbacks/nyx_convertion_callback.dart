import '../../nyx_converter.dart';

/// Callback triggered during media conversion.
///
/// Provides real-time information about the conversion state.
typedef NyxConvertionCallback = void Function(
  NyxStatus status, {
  /// Conversion progress from 0 to 100.
  double? progress,

  /// Current processing FPS.
  double? fps,

  /// Current conversion speed multiplier.
  double? speed,

  /// Error description when conversion fails.
  String? errorMessage,
});
