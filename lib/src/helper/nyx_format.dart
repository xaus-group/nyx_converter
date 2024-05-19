enum NyxFormat {
  // video
  avi,
  mp4,
  mkv,
  mov,
  ogg,
  // audio
  wav,
  flac,
}

extension NyxFormatCommandExtension on NyxFormat {
  String get command {
    switch (this) {
      case NyxFormat.avi:
        return 'avi';
      case NyxFormat.mp4:
        return 'avi';
      case NyxFormat.mkv:
        return 'avi';
      case NyxFormat.mov:
        return 'avi';
      case NyxFormat.ogg:
        return 'ogg';
      case NyxFormat.wav:
        return 'ogg';
      case NyxFormat.flac:
        return 'ogg';
    }
  }
}

extension NyxFormatNameExtension on NyxFormat {
  String get name {
    switch (this) {
      case NyxFormat.avi:
        return 'AVI (Audio Video Interleaved)';
      case NyxFormat.mp4:
        return 'MP4 (MPEG-4 Part 14)';
      case NyxFormat.mkv:
        return 'MKV (Matroska Video)';
      case NyxFormat.mov:
        return 'QuickTime / MOV';
      case NyxFormat.ogg:
        return 'Ogg';
      case NyxFormat.wav:
        return 'WAV / WAVE (Waveform Audio)';
      case NyxFormat.flac:
        return 'raw FLAC';
    }
  }
}
