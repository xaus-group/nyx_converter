import '../helper/nyx_audio_codec.dart';
import '../helper/nyx_channel.dart';
import '../helper/nyx_sample_rate.dart';
import '../helper/nyx_size.dart';
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
    NyxSize? size,
    int? audioBitrate,
    int? videoBitrate,
    NyxSampleRate? sampleRate,
    NyxChannelLayout? channelLayout,
  }) {
    final command = StringBuffer();

    command.write('-i "$inputPath" ');

    if (videoCodec != null) {
      command.write('-c:v ${videoCodec.command} ');
    }

    if (size != null) {
      final dimensions = size.command.split('x');

      command.write('-vf scale=${dimensions[0]}:${dimensions[1]} ');
    }

    if (videoBitrate != null) {
      command.write('-b:v ${videoBitrate}M ');
    }

    if (audioCodec != null) {
      command.write('-c:a ${audioCodec.command} ');
    }

    if (sampleRate != null) {
      command.write('-ar ${sampleRate.command} ');
    }

    if (channelLayout != null) {
      command.write('-ac ${channelLayout.command} ');
    }

    if (audioBitrate != null) {
      command.write('-b:a ${audioBitrate}k ');
    }

    command.write('"$outputFilePath"');

    return command.toString();
  }
}
