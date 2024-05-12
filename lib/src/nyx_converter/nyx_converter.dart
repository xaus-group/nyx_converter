import 'package:nyx_converter/src/helper/nyx_data.dart';

abstract class INyxConverter {
  /// convertTo return [Future<NyxData>]
  ///
  /// pick media file from device and get [filePath] of the media file,
  ///
  /// select a [outputPath] on device to save the converted media file,
  ///
  Future<NyxData> convertTo(filePath, outputPath,
      {format,
      videoCodec,
      audioCodec,
      width,
      height,
      bitrate,
      frequency,
      channel});
}

class _NyxConverter extends INyxConverter {
  static _NyxConverter? _ins;

  _NyxConverter._internal() {
    _ins = this;
  }

  factory _NyxConverter() => _ins ?? _NyxConverter._internal();

  @override
  Future<NyxData> convertTo(filePath, outputPath,
      {format,
      videoCodec,
      audioCodec,
      width,
      height,
      bitrate,
      frequency,
      channel}) {
    // TODO: implement convertTo
    throw UnimplementedError();
  }
}

/// Nyx Converter.
///
/// Method in the static class will help you to convert media files,
///
/// You can use `NyxConverter.convertTo` to convert media files:
///
/// ```dart
/// NyxData? result = await NyxCoverter.convertTo(
///   filePath,
///   outputPath,
///   format,
///   videoCodec,
///   audioCodec,
///   width,
///   height,
///   bitrate,
///   frequency,
///   channel
/// );
/// ```
///
/// [NyxData] include [path] of converted media file
///
/// You can use `NyxConverter.convertTo$.subscribe` to subscribe of [NyxConverter] process and get [percent] of complition, [time], [isDone]
///
///  ```dart
/// NyxConverter.convertTo$.subscribe((int percent, int time, bool isDone) {
///   // TODO: implement subscribe
/// });
///  ```
///
/// And `NyxConverter.convertTo$.kill` to stop all process of [NyxConverter] on any time.
///
/// ```dart
/// NyxConverter.convertTo$.kill();
/// ```
///
// ignore: non_constant_identifier_names
INyxConverter get NyxConverter => _NyxConverter();
