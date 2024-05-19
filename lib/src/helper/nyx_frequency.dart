enum NyxFrequency {
  hz48000,
  hz44100,
  hz22050,
}

extension FFmakeFrequencyCommandExtension on NyxFrequency {
  String get command {
    switch (this) {
      case NyxFrequency.hz48000:
        return '48000';
      case NyxFrequency.hz44100:
        return '44100';
      case NyxFrequency.hz22050:
        return '22050';
    }
  }
}

extension NyxFrequencyNameExtension on NyxFrequency {
  String get title {
    switch (this) {
      case NyxFrequency.hz48000:
        return '48000 Hz';
      case NyxFrequency.hz44100:
        return '44100 Hz';
      case NyxFrequency.hz22050:
        return '22050 Hz';
    }
  }
}
