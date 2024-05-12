enum NyxBitrate {
  k320,
  k256,
  k192,
  k128,
  k96,
}

extension NyxBitrateCommandExtension on NyxBitrate {
  String get command {
    switch (this) {
      case NyxBitrate.k320:
        return '320k';
      case NyxBitrate.k256:
        return '256k';
      case NyxBitrate.k192:
        return '192k';
      case NyxBitrate.k128:
        return '128k';
      case NyxBitrate.k96:
        return '96k';
    }
  }
}

extension NyxBitrateNameExtension on NyxBitrate {
  String get title {
    switch (this) {
      case NyxBitrate.k320:
        return '320 Kbps';
      case NyxBitrate.k256:
        return '256 Kbps';
      case NyxBitrate.k192:
        return '192 Kbps';
      case NyxBitrate.k128:
        return '128 Kbps';
      case NyxBitrate.k96:
        return '96 Kbps';
    }
  }
}
