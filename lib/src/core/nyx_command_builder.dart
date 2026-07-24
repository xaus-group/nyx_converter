import '../helper/nyx_audio_codec.dart';
import '../helper/nyx_video_codec.dart';

abstract final class NyxCommandBuilder {
  NyxCommandBuilder._();

  /// Builds the FFmpeg command based on the requested
  /// conversion options.
  ///
  /// Only non-null options are added to the generated command.
  static String build({
    required String inputPath,
    required String outputFilePath,
    NyxVideoCodec? videoCodec,
    NyxAudioCodec? audioCodec,
    int? audioBitrate,
    int? videoBitrate,
  }) {
    final command = StringBuffer();

    command.write('-i "$inputPath" ');

    if (videoCodec != null) {
      command.write('-c:v ${videoCodec.command} ');
    }

    if (videoBitrate != null) {
      command.write('-b:v ${videoBitrate}M ');
    }

    if (audioCodec != null) {
      command.write('-c:a ${audioCodec.command} ');
    }

    if (audioBitrate != null) {
      command.write('-b:a ${audioBitrate}k ');
    }

    command.write('"$outputFilePath"');

    return command.toString();
  }
}
