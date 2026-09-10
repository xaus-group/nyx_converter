<h1 align="center">Nyx Converter</h1>

<p align="center">
  <a href="https://pub.dev/packages/nyx_converter">
    <img src="https://img.shields.io/pub/v/nyx_converter.svg" alt="Pub package">
  </a>
  <a href="https://github.com/xaus-group/nyx_converter">
    <img src="https://img.shields.io/github/v/release/xaus-group/nyx_converter" alt="GitHub release">
  </a>
  <a href="https://github.com/xaus-group/nyx_converter">
    <img src="https://img.shields.io/github/stars/xaus-group/nyx_converter" alt="GitHub Stars">
  </a>
  <a href="https://github.com/xaus-group/nyx_converter/issues">
    <img src="https://img.shields.io/github/issues/xaus-group/nyx_converter" alt="Issues">
  </a>
  <a href="https://www.gnu.org/licenses/lgpl-3.0.en.html">
    <img src="https://img.shields.io/github/license/xaus-group/nyx_converter" alt="License">
  </a>
</p>

<p align="center">
  <img
    src="https://github.com/xaus-group/nyx_converter/raw/master/screenshots/logo.png"
    alt="Nyx Converter"
    width="240"
  >
</p>

<p align="center">
  <b>FFmpeg media conversion and inspection for Flutter.</b>
</p>

---

## What is Nyx Converter?

**Nyx Converter** is a Flutter package for working with audio and video files using FFmpeg.

It provides a simple API for:

- Media conversion
- Audio and video codecs
- Containers
- Bitrates
- Video size
- Audio sample rate
- Audio channel layout
- Real-time conversion progress
- Media information
- Thumbnail generation
- Conversion cancellation

FFmpeg command generation and execution are handled internally.

---

## Installation

Add Nyx Converter to your `pubspec.yaml`:

```yaml
dependencies:
  nyx_converter: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## Quick Start

Import the package:

```dart
import 'package:nyx_converter/nyx_converter.dart';
```

Convert a media file:

```dart
await NyxConverter.convertTo(
  '/storage/input.mp4',
  '/storage/output',
  container: NyxContainer.mp4,
  videoCodec: NyxVideoCodec.h264,
  audioCodec: NyxAudioCodec.aac,
  size: NyxSize.w1920h1080,
  sampleRate: NyxSampleRate.hz48000,
  channelLayout: NyxChannelLayout.stereo,
  videoBitrate: 5,
  audioBitrate: 192,
  fileName: 'converted',
  execution: (
    status, {
    progress,
    fps,
    speed,
    errorMessage,
  }) {
    switch (status) {
      case NyxStatus.running:
        print('Progress: ${progress ?? 0}%');
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

You can also use `convertTo` with only the options you need.

---

## More

Nyx Converter also provides APIs for:

```dart
NyxConverter.getMediaInfo(...)
```

```dart
NyxConverter.getThumbnail(...)
```

```dart
NyxConverter.kill()
```

See the Wiki for complete API usage, supported codecs and containers, configuration options, media information, thumbnails, callbacks, validation, and troubleshooting.

---

## Documentation

📚 **[Nyx Converter Wiki](https://github.com/xaus-group/nyx_converter/wiki)**

The Wiki contains the complete documentation:

- Audio Codecs
- Video Codecs
- Containers
- Audio Settings
- Video Settings
- Media Information
- Thumbnails
- Conversion Lifecycle
- Execution Callback

---

## Links

- 📦 [Pub.dev](https://pub.dev/packages/nyx_converter)
- 💻 [GitHub](https://github.com/xaus-group/nyx_converter)
- 📚 [Documentation](https://github.com/xaus-group/nyx_converter/wiki)
- 🐛 [Issues](https://github.com/xaus-group/nyx_converter/issues)

---

## Contributing

Contributions, bug reports, and feature requests are welcome.

Please see [CONTRIBUTING.md](https://github.com/xaus-group/nyx_converter/blob/master/CONTRIBUTING.md) before contributing.

---

## License

Nyx Converter is licensed under the **GNU LGPL v3.0** license.
