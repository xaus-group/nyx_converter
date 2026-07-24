/// A Flutter package for converting audio and video files using FFmpeg.
///
/// Supports:
/// - Container conversion
/// - Audio/video codec selection
/// - Bitrate configuration
/// - Progress tracking
library;

export './src/nyx_converter/nyx_converter.dart';

export './src/helper/nyx_status.dart';
export './src/helper/nyx_container.dart';
export './src/helper/nyx_audio_codec.dart';
export './src/helper/nyx_video_codec.dart';
export './src/helper/nyx_size.dart';
export './src/helper/nyx_frequency.dart';
export './src/helper/nyx_channel.dart';
export 'src/callbacks/nyx_convertion_callback.dart';
