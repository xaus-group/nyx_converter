# Changelog

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
