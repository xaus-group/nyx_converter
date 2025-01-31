# Nyx Converter [![Github release](https://img.shields.io/github/v/release/xaus-group/nyx_converter)](https://github.com/xaus-group/nyx_converter) [![pub package](https://img.shields.io/pub/v/nyx_converter.svg)](https://pub.dev/packages/nyx_converter) [![License](https://img.shields.io/github/license/xaus-group/nyx_converter)](https://www.gnu.org/licenses/lgpl-3.0.en.html) [![Github Stars](https://img.shields.io/github/stars/xaus-group/nyx_converter)](https://github.com/xaus-group/nyx_converter) [![Issues](https://img.shields.io/github/issues/xaus-group/nyx_converter)](https://github.com/xaus-group/nyx_converter/issues)

<p align="center"><img src="https://raw.githubusercontent.com/xaus-group/nyx_converter/master/screenshots/logo.png" alt="nyx_converter logo" width="240" ></p>

The `nyx_converter` package in Flutter empowers you to seamlessly convert media files between various formats, codecs, resolutions, bitrates, and audio properties. It utilizes the robust [ffmpeg](https://ffmpeg.org/) under the hood, providing a convenient and efficient solution for your media processing needs within your Flutter applications.

## Key Features

- **Extensive Container Support:** Convert a wide range of video and audio file containers.
- **Flexible Codec Control:** Specify desired video codecs (e.g., H.264, VP8) and audio codecs (e.g., AAC, MP3) to tailor the output file's characteristics.
- **Granular Resolution Management:** Define the exact width and height in pixels for the converted video, granting precise control over the output dimensions. *(will be added)*
- **Bitrate Optimization:** Set the bitrate (in kbps) to strike a balance between quality and file size, catering to different bandwidth requirements or storage constraints.
- **Audio Fine-Tuning:** Specify the sampling frequency (in Hz) and number of channels (mono or stereo) for the audio stream within the converted media file, allowing for customized audio output. *(will be added)*

## Installation

To use this package, add `nyx_converter` as a dependency in your pubspec.yaml file.

```yaml
dependencies:
  nyx_converter: <latest-version>
```

## Platform Support

The following table shows Android API level, iOS deployment target and macOS deployment target requirements in `nyx_converter` releases.

<table>
<thead>
<tr>
<th align="center">Android<br>API Level</th>
<th align="center">iOS Minimum<br>Deployment Target</th>
<th align="center">macOS Minimum<br>Deployment Target</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">24</td>
<td align="center">12.1</td>
<td align="center">10.15</td>
</tr>
</tbody>
</table>

## Using
**Import:** Import the package in your Dart code:

```dart
import 'package:nyx_converter/nyx_converter.dart';
```

**Widget Usage:** Use `.convertTo` method for initiate the media file path and desired output file path to save converted media file.
```dart
final filePath = 'path/to/my.mp4';
final outputPath = 'path/to/';
result =  NyxConverter.convertTo(
  filePath, // Specify the input file path
  outputPath, // Define the output file path
```
**[Container](https://pub.dev/documentation/nyx_converter/latest/nyx_converter/NyxContainer.html):** Choose the desired container for your output media file. [supported containers](https://github.com/xaus-group/nyx_converter/wiki/Container)

```dart
  container: NyxContainer.mp4,
```

**[Video Codec](https://pub.dev/documentation/nyx_converter/latest/nyx_converter/NyxVideoCodec.html):** Select the appropriate video codec for your media file. [supported video codecs](https://github.com/xaus-group/nyx_converter/wiki/Video-codec)
```dart
  videoCodec: NyxVideoCodec.h264
```

**[Audio Codec](https://pub.dev/documentation/nyx_converter/latest/nyx_converter/NyxAudioCodec.html):** Select the appropriate audio codec for your media file. [supported audio codecs](https://github.com/xaus-group/nyx_converter/wiki/Audio-codec)
```dart
  audioCodec: NyxAudioCodec.aac
```

**Bitrate:** Set the bitrate to balance between quality and file size. Typical values range from 96 kbps for low quality to 320 kbps for high quality audio.
```dart
  bitrate: 192
```

**Debug Mode:** Set true for get detailed logs
```dart
  debugMode: true,
```

**Output file name:** Set output file name
```dart
  fileName: 'new_name',
```

**Execution:** `execution` callback provides the path of the converted file and the status and messages of the conversion process.
```dart
  execution: (String? path, NyxStatus status, {String? errorMessage}) {
    //TODO: codes
  }
);
```

---

**Stop process:** Use `.kill` method to kill all `nyx_converter` processes.
```dart
NyxConverter.kill();
```

## Contributing
There is not much to contribute since the package serves its purpose, however, in chance of needing to bump or adjust some version, or any other suggestion for that matter, please read [CONTRIBUTING](https://github.com/xaus-group/nyx_converter/blob/master/CONTRIBUTING.md).