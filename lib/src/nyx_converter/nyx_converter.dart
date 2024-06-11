import 'package:nyx_converter/src/helper/nyx_audio_codec.dart';
import 'package:nyx_converter/src/helper/nyx_bitrate.dart';
import 'package:nyx_converter/src/helper/nyx_channel.dart';
import 'package:nyx_converter/src/helper/nyx_data.dart';
import 'package:nyx_converter/src/helper/nyx_container.dart';
import 'package:nyx_converter/src/helper/nyx_frequency.dart';
import 'package:nyx_converter/src/helper/nyx_size.dart';
import 'package:nyx_converter/src/helper/nyx_video_codec.dart';
import 'package:nyx_converter/src/nyx_converter/i_nyx_converter.dart';
import 'package:nyx_converter/src/nyx_converter/nyx_ff_converter.dart';
import 'package:nyx_converter/src/nyx_converter/nyx_helper.dart';

class _NyxConverter extends INyxConverter {
  static _NyxConverter? _ins;

  _NyxConverter._internal() {
    _ins = this;
  }

  factory _NyxConverter() => _ins ?? _NyxConverter._internal();

  @override
  Future<NyxData> convertTo(filePath, outputPath,
      {bool debugMode = false,
      String? fileName,
      NyxContainer? container,
      NyxVideoCodec? videoCodec,
      NyxAudioCodec? audioCodec,
      NyxSize? size,
      NyxBitrate? bitrate,
      NyxFrequency? frequency,
      NyxChannelLayout? channelLayout}) async {
    NyxHelper().verifyData(filePath, outputPath, fileName,
        container?.command ?? NyxHelper().getFileContainer(filePath));
    return NyxFFConverter().execute(
        NyxHelper().getCommand(
            filePath,
            NyxHelper().getOutPutFilePath(
                outputPath,
                fileName ?? NyxHelper().getFileBaseName(filePath),
                container?.command ?? NyxHelper().getFileContainer(filePath))),
        debugMode,
        NyxHelper().getOutPutFilePath(
            outputPath,
            fileName ?? NyxHelper().getFileBaseName(filePath),
            container?.command ?? NyxHelper().getFileContainer(filePath)));
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
