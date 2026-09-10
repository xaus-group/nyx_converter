/// A Flutter package for converting and inspecting audio and video files
/// using FFmpeg and FFprobe.
///
/// Supports:
/// - Container conversion
/// - Audio/video codec selection
/// - Bitrate configuration
/// - Progress tracking
/// - Media information
/// - Video thumbnails
library;

export './src/nyx_converter/nyx_converter.dart';

export './src/helper/nyx_status.dart';
export './src/helper/nyx_container.dart';
export './src/helper/nyx_audio_codec.dart';
export './src/helper/nyx_video_codec.dart';
export './src/helper/nyx_size.dart';
export 'src/helper/nyx_sample_rate.dart';
export './src/helper/nyx_channel.dart';

export './src/callbacks/nyx_convertion_callback.dart';

export './src/models/nyx_media_info.dart';
