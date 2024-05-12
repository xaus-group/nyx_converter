enum NyxCodec {
  h264,
  xvid,
  mp3,
  mp2,
  aac,
  mpeg4,
  mpeg2,
}

extension NyxCodecCommandExtension on NyxCodec {
  String get command {
    switch (this) {
      case NyxCodec.h264:
        return 'libx264';
      // return 'libx264 -preset slow -crf 22';
      case NyxCodec.xvid:
        return 'libxvid';
      case NyxCodec.mp3:
        return 'libmp3lame';
      case NyxCodec.mp2:
        return 'libtwolame';
      case NyxCodec.aac:
        return 'aac';
      // return 'libfdk_aac';
      case NyxCodec.mpeg4:
        return 'mpeg4';
      case NyxCodec.mpeg2:
        return 'mpeg2video';
    }
  }
}

extension NyxCodecNameExtension on NyxCodec {
  String get title {
    switch (this) {
      case NyxCodec.h264:
        return 'H.264';
      case NyxCodec.xvid:
        return 'XVID';
      case NyxCodec.mp3:
        return 'MP3';
      case NyxCodec.mp2:
        return 'MP2';
      case NyxCodec.aac:
        return 'AAC';
      case NyxCodec.mpeg4:
        return 'MPEG4';
      case NyxCodec.mpeg2:
        return 'MPEG2';
    }
  }
}
