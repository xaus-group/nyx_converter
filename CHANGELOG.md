# Changelog

## 0.4.1

Added:

- Added `Future` completion support for `convertTo`
- Added improved conversion lifecycle handling
- Added FFprobe based media validation before conversion
- Added Windows platform support

Improved:

- Refactored FFmpeg execution flow into a cleaner internal architecture
- Improved conversion callback reliability
- Improved error reporting during failed conversions
- Improved session management for running conversions
- Improved integration test stability
- Updated documentation and examples

Fixed:

- Fixed conversion completion timing issues
- Fixed progress callback handling during FFmpeg execution
- Fixed FFmpeg session cleanup after cancellation

## 0.4.0

Added:

- Real FFmpeg progress tracking (0–100%) using parsed time= logs
- Real-time FPS extraction (fps=)
- Real-time processing speed extraction (speed=1.2x)
- New structured execution callback:
  - status
  - progress
  - fps
  - speed
  - errorMessage

Improved

- Cleaner FFmpeg logging
- More accurate progress calculation using FFprobe duration

## 0.3.0

- Added audio bitrate
- Added video bitrate

## 0.2.0

- Added video codecs
- Added audio codecs
- bug fix

## 0.1.1

- kill all process method

## 0.1.0

The basic code has been written and the simple conversion of containers is the first possibility of this package

- media file container conversion
