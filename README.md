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
**Android**
- **[READ_EXTERNAL_STORAGE](https://developer.android.com/reference/android/Manifest.permission#READ_EXTERNAL_STORAGE) (API level 29 and below)**: This permission allows the app to access and read media files (videos, audio) stored on the device's external storage (SD card or internal storage). This is typically needed to read the input files for processing with `nyx_converter`.

- **[WRITE_EXTERNAL_STORAGE](https://developer.android.com/reference/android/Manifest.permission#WRITE_EXTERNAL_STORAGE) (API level 29 and below)**: This permission allows the app to write processed media files (edited videos, converted audio formats) to the device's external storage. This is needed if you want to save the output of `nyx_converter` operations.

- **READ_MEDIA_ Permissions (API level 30 and Above)**: These are a group of permissions introduced with Scoped Storage. They provide a more granular approach to accessing media files on the device.
  - [READ_MEDIA_VIDEO](https://developer.android.com/reference/android/Manifest.permission#READ_MEDIA_VIDEO): Allows reading video files.
  - [READ_MEDIA_AUDIO](https://developer.android.com/reference/android/Manifest.permission#READ_MEDIA_AUDIO): Allows reading audio files.

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

**Widget Usage:** Use `.convertTo` method for initiate the media file path and desired output file path to save converted media file.
```dart
final filePath = 'path/to/my.mp4';
final outputPath = 'path/to/';
NyxData? result =  NyxConverter.convertTo(
  filePath, // Specify the input file path
  outputPath, // Define the output file path
```
**[Container](https://xaus-group.github.io/nyx_converter/nyx_converter/NyxContainer.html):** Choose the desired container for your output media file.

<table>
<thead>
<tr>
<th align="center">Video</th>
<th align="center">Audio</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">AVI</td>
<td align="center">WAV</td>
</tr>
<tr>
<td align="center">MP4</td>
<td align="center">FLAC</td>
</tr>
<tr>
<td align="center">MKV</td>
<td align="center">OGG</td>
</tr>
<tr>
<td align="center">MOV</td>
<td align="center">AAC</td>
</tr>
<tr>
<td align="center">WebM</td>
<td align="center">MP3</td>
</tr>
</tbody>
</table>

```dart
  container: NyxContainer.mp4,
```
**Debug Mode:** Set true for get detailed logs
```dart
  debugMode: true,
```
**Output file name:** Set output file name
```dart
  fileName: 'new_name',
);
```

## TODO

```dart
final filePath = 'path/to/my.mp4';
final outputPath = 'path/to/';
NyxData? result =  NyxConverter.convertTo(
  //TODO: videoCodec: NyxVideoCodec.h264, // Specify the video codec (optional)
  //TODO: audioCodec: NyxAudioCodec.flac, // Define the audio codec (optional)
  //TODO: size: NyxSize.w1280h720, // Set the width and height in pixels (optional)
  //TODO: bitrate: NyxBitrate.k320, // Set the bitrate in kbps (optional)
  //TODO: frequency: NyxFrequency.hz48000, // Specify the sampling frequency in Hz (optional)
  //TODO: channelLayout: NyxChannelLayout.stereo // Define the number of channels (optional)
);

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