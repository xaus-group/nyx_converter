<h1 align="center">Nyx Converter</h1>

<p align="center">
  <a href="https://github.com/xaus-group/nyx_converter">
    <img src="https://img.shields.io/github/v/release/xaus-group/nyx_converter" alt="GitHub release">
  </a>
  <a href="https://pub.dev/packages/nyx_converter">
    <img src="https://img.shields.io/pub/v/nyx_converter.svg" alt="Pub package">
  </a>
  <a href="https://www.gnu.org/licenses/lgpl-3.0.en.html">
    <img src="https://img.shields.io/github/license/xaus-group/nyx_converter" alt="License">
  </a>
  <a href="https://github.com/xaus-group/nyx_converter">
    <img src="https://img.shields.io/github/stars/xaus-group/nyx_converter" alt="GitHub Stars">
  </a>
  <a href="https://github.com/xaus-group/nyx_converter/issues">
    <img src="https://img.shields.io/github/issues/xaus-group/nyx_converter" alt="Issues">
  </a>
</p>

<p align="center">
  <img
    src="screenshots/logo.png"
    alt="Nyx Converter"
    width="240"
  >
</p>

<p align="center">
  <b>
    A Flutter package that provides a simple and powerful API for converting,
    inspecting, and processing audio and video files.
  </b>
</p>

---

## 📖 Overview

`nyx_converter` is a Flutter package that provides a simple and powerful API for working with media files.

It allows Flutter applications to:

- 🔄 Convert media containers
- 🎬 Change video and audio codecs
- 🎚️ Configure bitrates
- 📊 Monitor conversion progress in real time
- 🖥️ Receive FPS and conversion speed updates
- ❌ Cancel running conversions
- ✅ Validate media files before processing
- 🔍 Read detailed media information
- 🖼️ Generate media thumbnails

Nyx Converter handles FFmpeg command generation internally, allowing developers to work with media files without manually writing FFmpeg commands.

---

## ✨ Features

| Feature                     | Status |
| :-------------------------- | :----: |
| Media container conversion  |   ✅   |
| Video codec conversion      |   ✅   |
| Audio codec conversion      |   ✅   |
| Audio bitrate control       |   ✅   |
| Video bitrate control       |   ✅   |
| Real-time progress callback |   ✅   |
| FPS monitoring              |   ✅   |
| Conversion speed monitoring |   ✅   |
| Cancel running conversions  |   ✅   |
| Input media validation      |   ✅   |
| Output validation           |   ✅   |
| Media information           |   ✅   |
| Media thumbnail generation  |   ✅   |
| Video resize                |   🚧   |
| Audio frequency control     |   🚧   |
| Audio channel layout        |   🚧   |

---

## 📦 Installation

Add the package to your `pubspec.yaml`.

```yaml
dependencies:
  nyx_converter: ^{{VERSION}}
```

Install dependencies:

```bash
flutter pub get
```

---

## 📱 Platform Support

| Platform | Minimum Requirement  |
| :------- | :------------------- |
| Android  | API 24+              |
| Kotlin   | 1.8.22+              |
| iOS      | 14.0+                |
| macOS    | 10.15+               |
| Windows  | Windows 10+ (x86_64) |

<details>
<summary><b>Supported architectures</b></summary>

<br>

### 🤖 Android

- `arm-v7a`
- `arm-v7a-neon`
- `arm64-v8a`
- `x86`
- `x86_64`

### 🍎 iOS

- `arm64` devices
- `arm64` / `x86_64` simulators

### 🖥️ macOS

- `arm64`
- `x86_64`

### 🪟 Windows

- `x86_64`

</details>

---

## 🚀 Quick Start

Import Nyx Converter:

```dart
import 'package:nyx_converter/nyx_converter.dart';
```

Convert a media file:

```dart
await NyxConverter.convertTo(
  '/storage/emulated/0/DCIM/input.mp4',
  '/storage/emulated/0/Movies',
  container: NyxContainer.mp4,
  execution: (
    status, {
    progress,
    fps,
    speed,
    errorMessage,
  }) {
    switch (status) {
      case NyxStatus.running:
        print('Progress: $progress%');
        break;

      case NyxStatus.completed:
        print('Conversion completed');
        break;

      case NyxStatus.failed:
        print(errorMessage);
        break;

      case NyxStatus.cancel:
        print('Conversion cancelled');
        break;
    }
  },
);
```

---

## ⚙️ Conversion Options

### 📦 Container

Define the output media container:

```dart
container: NyxContainer.mp4,
```

> 📚 Available containers: [Wiki → Container](https://github.com/xaus-group/nyx_converter/wiki/Container)

---

### 🎬 Video Codec

Change the video encoding codec:

```dart
videoCodec: NyxVideoCodec.h264,
```

> 📚 Available codecs: [Wiki → Video Codec](https://github.com/xaus-group/nyx_converter/wiki/Video-codec)

---

### 🔊 Audio Codec

Change the audio encoding codec:

```dart
audioCodec: NyxAudioCodec.aac,
```

> 📚 Available codecs: [Wiki → Audio Codec](https://github.com/xaus-group/nyx_converter/wiki/Audio-codec)

---

### 🎚️ Bitrate

Configure output quality and file size:

```dart
audioBitrate: 192,
videoBitrate: 5,
```

> 📚 More information: [Wiki → Bitrate](https://github.com/xaus-group/nyx_converter/wiki/Bitrate)

---

### 📝 Output File Name

By default, Nyx Converter keeps the original filename.

You can customize it:

```dart
fileName: 'converted_video',
```

---

### 🐛 Debug Logs

Enable detailed FFmpeg logs:

```dart
debugMode: true,
```


## 📡 Execution Callback

The execution callback provides real-time conversion updates.

The callback is optional. If it is not provided, conversion runs silently.

```dart
execution: (
  NyxStatus status, {
  double? progress,
  double? fps,
  double? speed,
  String? errorMessage,
}) {

},
```

### Status

| Status                | Description                      |
| :-------------------- | :------------------------------- |
| `NyxStatus.running`   | Conversion is running            |
| `NyxStatus.completed` | Conversion finished successfully |
| `NyxStatus.failed`    | Conversion failed                |
| `NyxStatus.cancel`    | Conversion cancelled             |

### Callback Data

| Property       | Description                             |
| :------------- | :-------------------------------------- |
| `progress`     | Conversion percentage from `0` to `100` |
| `fps`          | Current processing frames per second    |
| `speed`        | Current FFmpeg processing speed         |
| `errorMessage` | Error details when conversion fails     |


## 🛡️ Automatic Validation

Before starting conversion, Nyx Converter validates:

- ✅ Input file exists
- ✅ Media file is readable
- ✅ Media contains valid streams
- ✅ Output directory exists
- ✅ Output file does not already exist

If validation fails, conversion will not start and:

```dart
NyxStatus.failed
```

will be returned through the execution callback.


## 🛑 Cancel Conversion

Cancel all active conversions:

```dart
NyxConverter.kill();
```

## 🔍 Media Information

Get detailed information about an audio or video file:

```dart
final NyxMediaInfo info = await NyxConverter.getMediaInfo(
  '/storage/emulated/0/Movies/video.mp4',
);

print('File: ${info.fileName}');
print('Format: ${info.format}');
print('Duration: ${info.duration}');
print('Has video: ${info.hasVideo}');
print('Has audio: ${info.hasAudio}');
```

Video and audio information is available through `info.video` and `info.audio`.

> 📚 Full documentation and examples: [Wiki → Media Info](https://github.com/xaus-group/nyx_converter/wiki/Media-Info)

---

## 🖼️ Media Thumbnail

Generate a thumbnail from a media file:

```dart
final Uint8List thumbnail = await NyxConverter.getThumbnail(
  '/storage/emulated/0/Movies/video.mp4',
  time: const Duration(seconds: 5),
);
```

Display it in Flutter:

```dart
Image.memory(thumbnail);
```

> 📚 Full documentation and examples: [Wiki → Thumbnail](https://github.com/xaus-group/nyx_converter/wiki/Thumbnail)

---

## 📚 Documentation

Detailed documentation is available in the Wiki:

- [Container](https://github.com/xaus-group/nyx_converter/wiki/Container)
- [Video Codec](https://github.com/xaus-group/nyx_converter/wiki/Video-codec)
- [Audio Codec](https://github.com/xaus-group/nyx_converter/wiki/Audio-codec)
- [Bitrate](https://github.com/xaus-group/nyx_converter/wiki/Bitrate)
- [Media Info](https://github.com/xaus-group/nyx_converter/wiki/Media-Info)
- [Thumbnail](https://github.com/xaus-group/nyx_converter/wiki/Thumbnail)

> 🔗 **Wiki:** https://github.com/xaus-group/nyx_converter/wiki

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome.

> 📄 Please read the [contribution guide](https://github.com/xaus-group/nyx_converter/blob/master/CONTRIBUTING.md).

---

## 📄 License

Nyx Converter is licensed under the **GNU LGPL v3.0** license.
