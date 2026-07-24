import 'package:flutter_test/flutter_test.dart';
import 'package:nyx_converter/src/core/nyx_path_helper.dart';

void main() {
  group('NyxPathHelper', () {
    test('gets file base name correctly', () {
      final result = NyxPathHelper.getFileBaseName(
        '/movies/video.mp4',
      );

      expect(
        result,
        'video',
      );
    });

    test('gets file container correctly', () {
      final result = NyxPathHelper.getFileContainer(
        '/movies/video.mp4',
      );

      expect(
        result,
        'mp4',
      );
    });

    test('builds output path correctly', () {
      final result = NyxPathHelper.getOutputFilePath(
        '/movies',
        'holiday',
        'mp4',
      );

      expect(
        result,
        '/movies/holiday.mp4',
      );
    });
  });
}
