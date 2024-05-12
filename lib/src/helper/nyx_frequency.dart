enum FFmakeFrequency {
  hz48000,
  hz44100,
  hz22050,
}

extension FFmakeFrequencyCommandExtension on FFmakeFrequency {
  String get command {
    switch (this) {
      case FFmakeFrequency.hz48000:
        return '48000';
      case FFmakeFrequency.hz44100:
        return '44100';
      case FFmakeFrequency.hz22050:
        return '22050';
    }
  }
}

extension FFmakeFrequencyNameExtension on FFmakeFrequency {
  String get title {
    switch (this) {
      case FFmakeFrequency.hz48000:
        return '48000 Hz';
      case FFmakeFrequency.hz44100:
        return '44100 Hz';
      case FFmakeFrequency.hz22050:
        return '22050 Hz';
    }
  }
}
