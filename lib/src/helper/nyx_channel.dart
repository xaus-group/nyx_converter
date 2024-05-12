enum NyxChannel { stereo, mono }

extension NyxChannelNameExtension on NyxChannel {
  String get title {
    switch (this) {
      case NyxChannel.stereo:
        return 'Stereo';
      case NyxChannel.mono:
        return 'Mono';
    }
  }
}
