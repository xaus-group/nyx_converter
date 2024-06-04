# Nyx Converter [![Github release](https://img.shields.io/github/v/release/xaus-group/nyx_converter)](https://github.com/xaus-group/nyx_converter) [![pub package](https://img.shields.io/pub/v/nyx_converter.svg)](https://pub.dev/packages/nyx_converter) [![License](https://img.shields.io/github/license/xaus-group/nyx_converter)](https://www.gnu.org/licenses/lgpl-3.0.en.html) [![Github Stars](https://img.shields.io/github/stars/xaus-group/nyx_converter)](https://github.com/xaus-group/nyx_converter) [![Issues](https://img.shields.io/github/issues/xaus-group/nyx_converter)](https://github.com/xaus-group/nyx_converter/issues)

<p align="center"><img src="https://raw.githubusercontent.com/xaus-group/nyx_converter/master/screenshots/logo.png" alt="nyx_converter logo" width="240" ></p>

The `nyx_converter` widget in Flutter empowers you to seamlessly convert media files between various formats, codecs, resolutions, bitrates, and audio properties. It utilizes the robust ffmpeg library under the hood, providing a convenient and efficient solution for your media processing needs within your Flutter applications.

## Key Features

- **Extensive Container Support:** Convert a wide range of video and audio file containers.
- **Flexible Codec Control:** Specify desired video codecs (e.g., H.264, VP8) and audio codecs (e.g., AAC, MP3) to tailor the output file's characteristics.
- **Granular Resolution Management:** Define the exact width and height in pixels for the converted video, granting precise control over the output dimensions.
- **Bitrate Optimization:** Set the bitrate (in kbps) to strike a balance between quality and file size, catering to different bandwidth requirements or storage constraints.
- **Audio Fine-Tuning:** Specify the sampling frequency (in Hz) and number of channels (mono or stereo) for the audio stream within the converted media file, allowing for customized audio output.

## Installation
download nyx_converter to path `./widgets/nyx_converter` then add as a dependency in your pubspec.yaml file:
```yaml
dependencies:
  nyx_converter:
    path: ./widgets/nyx_converter
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

## Configuration
<details>
<summary>Android</summary>
Adding the <a href="https://developer.android.com/reference/android/Manifest.permission#READ_EXTERNAL_STORAGE">READ_EXTERNAL_STORAGE</a> permission to the <code>AndroidManifest.xml</code> file grants your app the ability to access and read files stored on the external storage of an Android device.
<code><uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/></code>

</details>
<details>
<summary>iOS</summary>
TODO
</details>

<details>
<summary>macOS</summary>
TODO
</details>

## Using
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
  NyxContainer.mp4, // Set the desired output format
  debugMode: true, // Set true for get detailed logs
  fileName: 'new_name', // Set output file name
  //TODO: videoCodec: NyxVideoCodec.h264, // Specify the video codec (optional)
  //TODO: audioCodec: NyxAudioCodec.flac, // Define the audio codec (optional)
  //TODO: size: NyxSize.w1280h720, // Set the width and height in pixels (optional)
  //TODO: bitrate: NyxBitrate.k320, // Set the bitrate in kbps (optional)
  //TODO: frequency: NyxFrequency.hz48000, // Specify the sampling frequency in Hz (optional)
  //TODO: channelLayout: NyxChannelLayout.stereo // Define the number of channels (optional)
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