# Nyx Converter

The nyx_converter widget in Flutter empowers you to seamlessly convert media files between various formats, codecs, resolutions, bitrates, and audio properties. It utilizes the robust ffmpeg library under the hood, providing a convenient and efficient solution for your media processing needs within your Flutter applications.

## Key Features

- **Extensive Container Support:** Convert a wide range of video and audio file containers.
- **Flexible Codec Control:** Specify desired video codecs (e.g., H.264, VP8) and audio codecs (e.g., AAC, MP3) to tailor the output file's characteristics.
- **Granular Resolution Management:** Define the exact width and height in pixels for the converted video, granting precise control over the output dimensions.
- **Bitrate Optimization:** Set the bitrate (in kbps) to strike a balance between quality and file size, catering to different bandwidth requirements or storage constraints.
- **Audio Fine-Tuning:** Specify the sampling frequency (in Hz) and number of channels (mono or stereo) for the audio stream within the converted media file, allowing for customized audio output.

## Usage

**Installation:** download nyx_converter to path `./widgets/nyx_converter` then add as a dependency in your pubspec.yaml file:
```yaml
dependencies:
nyx_converter:
  path: ./widgets/nyx_converter
```

**Import:** Import the package in your Dart code:

```dart
import 'package:nyx_converter/nyx_converter.dart';
```

**Widget Usage:** Utilize the `NyxConverter` widget to initiate the conversion process:
```dart
final filePath = 'path/to/my.mp4';
final outputPath = 'path/to/';
NyxData? result =  NyxConverter.convertTo(
  filePath, // Specify the input file path
  outputPath, // Define the output file path
  container: NyxContainer.mp4, // Set the desired output format (optional)
  videoCodec: NyxVideoCodec.h264, // Specify the video codec (optional)
  audioCodec: NyxAudioCodec.flac, // Define the audio codec (optional)
  size: NyxSize.w1280h720, // Set the width and height in pixels (optional)
  bitrate: NyxBitrate.k320, // Set the bitrate in kbps (optional)
  frequency: NyxFrequency.hz48000, // Specify the sampling frequency in Hz (optional)
  channelLayout: NyxChannelLayout.stereo // Define the number of channels (optional)
);
```

## TODO

```dart
NyxCoverter.convertTo$.subscribe((int percent, int time, bool isDone) {
      printDebug('percent on complition $percent');
      printDebug('time of file process $time');
      printDebug('process is done $isDone');
});

if(result.path != null) {
    //TODO: converted file is ready
}

NyxConverter.convertTo$.kill(); // kill all process of NyxConverter widget
```