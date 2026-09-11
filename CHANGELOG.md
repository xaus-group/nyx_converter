# Changelog

## 1.0.1

### Added

* Added new video resolutions to NyxSize: 854x480, 2560x1440, 1080x608, 1080x1350, 1080x1080, and 1080x1920.
* Added name and title mappings for all new sizes.

### Improved

* Improved NyxSize titles (720p HD, 1080p Full HD, 4K UHD, 480p SD).
* Updated wiki and documentation with the new supported video sizes.

## 1.0.0

The first stable release of Nyx Converter.

### Added

* Added media information retrieval with `getMediaInfo`.
* Added `NyxMediaInfo`, `NyxVideoInfo`, and `NyxAudioInfo` models.
* Added video thumbnail generation with `getThumbnail`.
* Added thumbnail position support.
* Added video size selection with `NyxSize`.
* Added audio sample rate selection with `NyxSampleRate`.
* Added audio channel layout selection with `NyxChannelLayout`.
* Added audio codec support with `NyxAudioCodec`.
* Added video codec support with `NyxVideoCodec`.
* Added media container support with `NyxContainer`.
* Added audio bitrate support.
* Added video bitrate support.
* Added real-time conversion progress tracking.
* Added FPS and processing speed tracking.
* Added structured conversion execution callbacks.
* Added FFprobe-based media validation.
* Added Windows platform support.

### Improved

* Improved FFmpeg execution and conversion lifecycle handling.
* Improved conversion callback reliability.
* Improved error reporting.
* Improved FFmpeg session management and cleanup.
* Improved media inspection and validation.
* Improved integration test stability.
* Updated example application with media information and thumbnail previews.
* Updated documentation and GitHub Wiki.
* Expanded public API documentation and examples.

### Fixed

* Fixed conversion completion timing issues.
* Fixed progress callback handling during FFmpeg execution.
* Fixed FFmpeg session cleanup after cancellation.
* Fixed various conversion and integration issues.

## 0.5.0

### Added

* Added `getMediaInfo` for retrieving media metadata and stream information.
* Added `getThumbnail` for generating video thumbnails as `Uint8List`.
* Added thumbnail position support.
* Added `NyxMediaInfo`, `NyxVideoInfo`, and `NyxAudioInfo` models.

### Improved

* Updated the example app with media information and thumbnail preview.
* Updated documentation and GitHub Wiki.

## 0.4.1

### Added

* Added `Future` completion support for `convertTo`.
* Added improved conversion lifecycle handling.
* Added FFprobe-based media validation before conversion.
* Added Windows platform support.

### Improved

* Refactored FFmpeg execution into a cleaner internal architecture.
* Improved conversion callback reliability.
* Improved error reporting during failed conversions.
* Improved session management for running conversions.
* Improved integration test stability.
* Updated documentation and examples.

### Fixed

* Fixed conversion completion timing issues.
* Fixed progress callback handling during FFmpeg execution.
* Fixed FFmpeg session cleanup after cancellation.

## 0.4.0

### Added

* Added real FFmpeg progress tracking from 0–100%.
* Added real-time FPS extraction.
* Added real-time processing speed extraction.
* Added structured execution callbacks.

### Improved

* Improved FFmpeg logging.
* Improved progress calculation using FFprobe duration.

## 0.3.0

### Added

* Added audio bitrate support.
* Added video bitrate support.

## 0.2.0

### Added

* Added video codec support.
* Added audio codec support.

### Fixed

* Fixed various conversion issues.

## 0.1.1

### Added

* Added support for terminating all running FFmpeg processes.

## 0.1.0

### Added

* Added the initial FFmpeg conversion implementation.
* Added media container conversion support.
