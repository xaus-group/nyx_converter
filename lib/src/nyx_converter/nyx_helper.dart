import 'dart:io';

import 'package:path/path.dart';

class NyxHelper {
  static NyxHelper? _ins;

  NyxHelper._internal() {
    _ins = this;
  }

  factory NyxHelper() => _ins ?? NyxHelper._internal();

  // check all input data
  verifyData(
    String filePath,
    String outputPath,
    String cntinr, {
    String? fileName,
  }) {
    // Check input file
    if (!File(filePath).existsSync()) {
      throw Exception('[nyx_converter] The imported file does not exist.');
    }
    // Check output directory existance
    else if (!Directory(outputPath).existsSync()) {
      throw Exception('[nyx_converter] The directory entered does not exist.');
    }
    // // Check output file existance
    else if (File(
            '$outputPath/${fileName ?? getFileBaseName(filePath)}.$cntinr')
        .existsSync()) {
      throw Exception(
          '[nyx_converter] The output file already exists please change the file name');
    }
    // check input file have container or not
    else if (getFileContainer(filePath).isEmpty) {
      throw Exception(
          '[nyx_converter] The imported file does not have the specified container');
    }
    // verify input file name
    else if (fileName != null && !verifyFileName(fileName)) {
      throw Exception(
          '[nyx_converter] The file name must not contain the character "|\\?*<\":>+[]/\'".');
    }
  }

  String getCommand(
    String filePath,
    String outputFilePath, // storage/emulated/0/Movies/name123.mp4
    //TODO: {NyxVideoCodec? videoCodec,
    // NyxAudioCodec? audioCodec,
    // NyxSize? size,
    // NyxBitrate? bitrate,
    // NyxFrequency? frequency,
    // NyxChannelLayout? channelLayout}
  ) {
    String command = "";
    command += "-i '$filePath' ";
    //TODO if (videoCodec != null) {
    //   command += "-c:v ${videoCodec.command} ";
    // }
    // if (audioCodec != null) {
    //   // sets the audio codec (MP3=>libmp3lame, AAC=>libfdk_aac, ...)
    //   command += "-c:a ${audioCodec.command} ";
    // }
    // if (frequency != null) {
    //   // sets the audio sample rate to 48000Hz,...
    //   command += "-ar ${frequency.command} ";
    // }
    // if (bitrate != null) {
    //   // sets the audio bitrate to 320kbps, 256kbps, ...
    //   command += "-b:a ${bitrate.command} ";
    // }
    // if (channelLayout != null) {
    //   if (channelLayout.title == 'Stereo') {
    //     // sets the audio channels to stereo
    //     command += "-ac 2 ";
    //   }
    //   if (channelLayout.title == 'Mono') {
    //     // sets the audio channels to mono
    //     command += "-ac 1 ";
    //   }
    // }
    // if (size != null) {
    //   command += "-s $size ";
    // }

    command += "'$outputFilePath'";

    return command;
  }

  // return => 123name
  String getFileBaseName(String filePath) => basenameWithoutExtension(filePath);

  // return => /storage/emulated/0/Movies/name123.mp4
  String getOutPutFilePath(String outputPath, String fileName,
          String container) => // outputPath: /storage/emulated/0/Movies,
      // fileName: name123
      // container: mp4
      // => /storage/emulated/0/Movies/name123.mp4
      "$outputPath/$fileName.$container";

  String getFileContainer(String filePath) => extension(filePath);

  bool verifyFileName(String fileName) {
    final unwantedCharsRegex = RegExp(r'[|\\?\<\":\+\[\]\/]');
    return !unwantedCharsRegex.hasMatch(fileName);
  }
}
