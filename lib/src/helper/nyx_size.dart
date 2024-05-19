enum NyxSize { w1280h720 }

extension NyxSizeCommandExtension on NyxSize {
  String get command {
    switch (this) {
      case NyxSize.w1280h720:
        return '1280x720';
    }
  }
}

extension NyxSizeNameExtension on NyxSize {
  String get name {
    switch (this) {
      case NyxSize.w1280h720:
        return 'HD';
    }
  }
}
