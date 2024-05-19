enum NyxVideoCodec { h264, h265, xvid, vp8, vp9, av1, mpeg4, mpeg2 }

extension NyxVideoCodecCommandExtension on NyxVideoCodec {
  String get command {
    switch (this) {
      case NyxVideoCodec.h264:
        return 'libx264';
      case NyxVideoCodec.h265:
        return 'libx265';
      case NyxVideoCodec.xvid:
        return 'libxvid';
      case NyxVideoCodec.vp8:
        return 'libvpx';
      case NyxVideoCodec.vp9:
        return 'libvpx-vp9';
      case NyxVideoCodec.av1:
        return 'libaom-av1';
      case NyxVideoCodec.mpeg4:
        return 'mpeg4';
      case NyxVideoCodec.mpeg2:
        return 'mpeg2video';
    }
  }
}

extension NyxVideoCodecTitleExtension on NyxVideoCodec {
  String get title {
    switch (this) {
      case NyxVideoCodec.h264:
        return 'Advanced Video Coding (AVC)';
      case NyxVideoCodec.h265:
        return 'High Efficiency Video Coding (HEVC)';
      case NyxVideoCodec.xvid:
        return 'Xvid MPEG-4 Video Codec';
      case NyxVideoCodec.vp8:
        return 'On2 VP8';
      case NyxVideoCodec.vp9:
        return 'Google VP9';
      case NyxVideoCodec.av1:
        return 'AOMedia Video 1';
      case NyxVideoCodec.mpeg4:
        return 'MPEG-4 Part 2';
      case NyxVideoCodec.mpeg2:
        return 'MPEG-2 Video';
    }
  }
}

extension NyxVideoCodecNameExtension on NyxVideoCodec {
  String get name {
    switch (this) {
      case NyxVideoCodec.h264:
        return 'H.264';
      case NyxVideoCodec.h265:
        return 'H.265';
      case NyxVideoCodec.xvid:
        return 'Xvid';
      case NyxVideoCodec.vp8:
        return 'VP8';
      case NyxVideoCodec.vp9:
        return 'VP9';
      case NyxVideoCodec.av1:
        return 'AV1';
      case NyxVideoCodec.mpeg4:
        return 'MPEG-4';
      case NyxVideoCodec.mpeg2:
        return 'MPEG-2';
    }
  }
}
