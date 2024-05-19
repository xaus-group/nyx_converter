enum NyxAudioCodec { mp3, mp2, wma, aac, oog, flac, alac, dsd, pcmS16le }

extension NyxAudioCodecCommandExtension on NyxAudioCodec {
  String get command {
    switch (this) {
      case NyxAudioCodec.mp3:
        return 'libmp3lame';
      case NyxAudioCodec.mp2:
        return 'mp2';
      case NyxAudioCodec.wma:
        return 'wmav2';
      case NyxAudioCodec.aac:
        return 'aac';
      case NyxAudioCodec.oog:
        return 'libvorbis';
      case NyxAudioCodec.flac:
        return 'flac';
      case NyxAudioCodec.alac:
        return 'alas';
      case NyxAudioCodec.dsd:
        return 'dsd';
      case NyxAudioCodec.pcmS16le:
        return 'pcm_s16le';
    }
  }
}

extension NyxAudioCodecTitleExtension on NyxAudioCodec {
  String get title {
    switch (this) {
      case NyxAudioCodec.mp3:
        return 'MPEG-1 Audio Layer III or MPEG-2 Audio Layer III';
      case NyxAudioCodec.mp2:
        return 'MPEG-1 Audio Layer II';
      case NyxAudioCodec.wma:
        return 'Windows Media Audio';
      case NyxAudioCodec.aac:
        return 'Advanced Audio Coding';
      case NyxAudioCodec.oog:
        return 'Ogg Vorbis';
      case NyxAudioCodec.flac:
        return 'Free Lossless Audio Codec';
      case NyxAudioCodec.alac:
        return 'Apple Lossless Audio Codec';
      case NyxAudioCodec.dsd:
        return 'Direct Stream Digital';
      case NyxAudioCodec.pcmS16le:
        return 'Pulse Code Modulation Signed 16-bit Little Endian';
    }
  }
}

extension NyxAudioCodecNameExtension on NyxAudioCodec {
  String get name {
    switch (this) {
      case NyxAudioCodec.mp3:
        return 'MP3';
      case NyxAudioCodec.mp2:
        return 'MP2';
      case NyxAudioCodec.wma:
        return 'WMA';
      case NyxAudioCodec.aac:
        return 'AAC';
      case NyxAudioCodec.oog:
        return 'OGG';
      case NyxAudioCodec.flac:
        return 'FLAC';
      case NyxAudioCodec.alac:
        return 'ALAC';
      case NyxAudioCodec.dsd:
        return 'DSD';
      case NyxAudioCodec.pcmS16le:
        return 'PCM S16LE';
    }
  }
}
