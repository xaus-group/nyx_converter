import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nyx_converter/nyx_converter.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: NyxExampleApp()),
  );
}

class NyxExampleApp extends StatefulWidget {
  const NyxExampleApp({super.key});

  @override
  State<NyxExampleApp> createState() => _NyxExampleAppState();
}

class _NyxExampleAppState extends State<NyxExampleApp> {
  // ---------------------------------------------------------------------------
  // Selected file
  // ---------------------------------------------------------------------------

  String? inputPath;

  // ---------------------------------------------------------------------------
  // Media information
  // ---------------------------------------------------------------------------

  NyxMediaInfo? mediaInfo;

  // Thumbnail returned directly as bytes.
  Uint8List? thumbnail;

  bool loadingMediaInfo = false;
  bool loadingThumbnail = false;

  // ---------------------------------------------------------------------------
  // Conversion
  // ---------------------------------------------------------------------------

  Directory? outputDirectory;

  NyxContainer container = NyxContainer.mp4;
  NyxVideoCodec videoCodec = NyxVideoCodec.h264;
  NyxAudioCodec audioCodec = NyxAudioCodec.aac;

  final audioBitrateController = TextEditingController(text: '128');
  final videoBitrateController = TextEditingController(text: '5');

  double progress = 0;
  double? fps;
  double? speed;

  bool converting = false;
  bool completed = false;

  @override
  void dispose() {
    audioBitrateController.dispose();
    videoBitrateController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Pick media
  // ---------------------------------------------------------------------------

  Future<void> pickInput() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result == null) {
      return;
    }

    final path = result.files.single.path;

    if (path == null) {
      _showError('Unable to get the selected file path.');
      return;
    }

    setState(() {
      inputPath = path;

      // Clear previous information.
      mediaInfo = null;
      thumbnail = null;

      loadingMediaInfo = true;
      loadingThumbnail = true;

      // Reset conversion state.
      completed = false;
      progress = 0;
      fps = null;
      speed = null;
    });

    // Get media information and thumbnail independently.
    await Future.wait([_loadMediaInfo(path), _loadThumbnail(path)]);
  }

  // ---------------------------------------------------------------------------
  // Get Media Info
  // ---------------------------------------------------------------------------

  Future<void> _loadMediaInfo(String path) async {
    try {
      final info = await NyxConverter.getMediaInfo(path);

      if (!mounted) {
        return;
      }

      setState(() {
        mediaInfo = info;
        loadingMediaInfo = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        loadingMediaInfo = false;
      });

      _showError('Unable to read media information.\n\n$e');
    }
  }

  // ---------------------------------------------------------------------------
  // Get Thumbnail
  // ---------------------------------------------------------------------------

  Future<void> _loadThumbnail(String path) async {
    try {
      final bytes = await NyxConverter.getThumbnail(path);

      if (!mounted) {
        return;
      }

      setState(() {
        thumbnail = bytes;
        loadingThumbnail = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        loadingThumbnail = false;
        thumbnail = null;
      });

      // Thumbnail failure should not prevent displaying media information.
      debugPrint('Nyx thumbnail error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Output directory
  // ---------------------------------------------------------------------------

  Future<void> selectOutput() async {
    final directory = await getDownloadsDirectory();

    if (!mounted) {
      return;
    }

    setState(() {
      outputDirectory = directory;
    });
  }

  // ---------------------------------------------------------------------------
  // Convert
  // ---------------------------------------------------------------------------

  Future<void> convert() async {
    if (inputPath == null) {
      _showError('Please select a media file.');
      return;
    }

    final directory = outputDirectory ?? await getDownloadsDirectory();

    if (directory == null) {
      _showError('Output directory not found.');
      return;
    }

    setState(() {
      converting = true;
      completed = false;

      progress = 0;
      fps = null;
      speed = null;
    });

    try {
      await NyxConverter.convertTo(
        inputPath!,
        directory.path,
        container: container,
        videoCodec: videoCodec,
        audioCodec: audioCodec,
        audioBitrate: int.tryParse(audioBitrateController.text),
        videoBitrate: int.tryParse(videoBitrateController.text),
        fileName: 'nyx_output',
        debugMode: true,
        execution:
            (
              NyxStatus status, {
              String? errorMessage,
              double? progress,
              double? fps,
              double? speed,
            }) {
              if (!mounted) {
                return;
              }

              if (status == NyxStatus.running) {
                setState(() {
                  this.progress = progress ?? 0;
                  this.fps = fps;
                  this.speed = speed;
                });
              }

              if (status == NyxStatus.completed) {
                setState(() {
                  converting = false;
                  completed = true;
                  this.progress = 100;
                });
              }

              if (status == NyxStatus.failed) {
                setState(() {
                  converting = false;
                });

                _showError(errorMessage ?? 'Conversion failed.');
              }

              if (status == NyxStatus.cancel) {
                setState(() {
                  converting = false;
                });
              }
            },
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        converting = false;
      });

      _showError(e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Cancel
  // ---------------------------------------------------------------------------

  void cancel() {
    NyxConverter.kill();

    setState(() {
      converting = false;
    });
  }

  // ---------------------------------------------------------------------------
  // Error dialog
  // ---------------------------------------------------------------------------

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Format duration
  // ---------------------------------------------------------------------------

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return '--';
    }

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  // ---------------------------------------------------------------------------
  // Format file size
  // ---------------------------------------------------------------------------

  String _formatFileSize(int? bytes) {
    if (bytes == null) {
      return '--';
    }

    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    }

    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }

    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  // ---------------------------------------------------------------------------
  // Format bitrate
  // ---------------------------------------------------------------------------

  String _formatBitrate(int? bitrate) {
    if (bitrate == null) {
      return '--';
    }

    if (bitrate >= 1000000) {
      return '${(bitrate / 1000000).toStringAsFixed(2)} Mbps';
    }

    if (bitrate >= 1000) {
      return '${(bitrate / 1000).toStringAsFixed(0)} kbps';
    }

    return '$bitrate bps';
  }

  // ---------------------------------------------------------------------------
  // Format FPS
  // ---------------------------------------------------------------------------

  String _formatFps(double? fps) {
    if (fps == null) {
      return '--';
    }

    return '${fps.toStringAsFixed(2)} fps';
  }

  // ---------------------------------------------------------------------------
  // Media information UI
  // ---------------------------------------------------------------------------

  Widget _buildMediaInfo() {
    if (loadingMediaInfo) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (mediaInfo == null) {
      return const SizedBox.shrink();
    }

    final info = mediaInfo!;
    final video = info.video;
    final audio = info.audio;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Media Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // General information
            const Text(
              'General',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            _infoRow('File name', info.fileName),

            _infoRow('Format', info.format ?? '--'),

            _infoRow('File size', _formatFileSize(info.size)),

            _infoRow('Duration', _formatDuration(info.duration)),

            _infoRow('Type', _mediaType(info)),

            _infoRow('Has video', info.hasVideo ? 'Yes' : 'No'),

            _infoRow('Has audio', info.hasAudio ? 'Yes' : 'No'),

            // Video
            if (info.hasVideo && video != null) ...[
              const SizedBox(height: 20),

              const Text(
                'Video',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              _infoRow('Codec', video.codec ?? '--'),

              _infoRow('Resolution', _resolution(video.width, video.height)),

              _infoRow('Width', video.width?.toString() ?? '--'),

              _infoRow('Height', video.height?.toString() ?? '--'),

              _infoRow('FPS', _formatFps(video.fps)),

              _infoRow('Bitrate', _formatBitrate(video.bitrate)),
            ],

            // Audio
            if (info.hasAudio && audio != null) ...[
              const SizedBox(height: 20),

              const Text(
                'Audio',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              _infoRow('Codec', audio.codec ?? '--'),

              _infoRow('Bitrate', _formatBitrate(audio.bitrate)),

              _infoRow(
                'Sample rate',
                audio.sampleRate != null ? '${audio.sampleRate} Hz' : '--',
              ),

              _infoRow('Channels', audio.channels?.toString() ?? '--'),
            ],
          ],
        ),
      ),
    );
  }

  String _mediaType(NyxMediaInfo info) {
    if (info.hasVideo && info.hasAudio) {
      return 'Video + Audio';
    }

    if (info.hasVideo) {
      return 'Video';
    }

    if (info.hasAudio) {
      return 'Audio';
    }

    return 'Unknown';
  }

  String _resolution(int? width, int? height) {
    if (width == null || height == null) {
      return '--';
    }

    return '$width × $height';
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Thumbnail UI
  // ---------------------------------------------------------------------------

  Widget _buildThumbnail() {
    if (loadingThumbnail) {
      return const Card(
        child: SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (thumbnail == null) {
      return const SizedBox.shrink();
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Thumbnail',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.memory(thumbnail!, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Dropdown
  // ---------------------------------------------------------------------------

  Widget _dropdown<T>(
    String title,
    T value,
    List<T> items,
    ValueChanged<T> onChanged,
  ) {
    return DropdownButton<T>(
      value: value,
      isExpanded: true,
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString().split('.').last.toUpperCase()),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nyx Converter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // -------------------------------------------------------------------
          // Select file
          // -------------------------------------------------------------------
          ElevatedButton.icon(
            onPressed: loadingMediaInfo || loadingThumbnail ? null : pickInput,
            icon: const Icon(Icons.video_file),
            label: const Text('Select Media File'),
          ),

          if (inputPath != null) ...[
            const SizedBox(height: 8),

            Text(inputPath!, style: const TextStyle(fontSize: 12)),
          ],

          const SizedBox(height: 16),

          // -------------------------------------------------------------------
          // Thumbnail
          // -------------------------------------------------------------------
          _buildThumbnail(),

          const SizedBox(height: 16),

          // -------------------------------------------------------------------
          // Media information
          // -------------------------------------------------------------------
          _buildMediaInfo(),

          const SizedBox(height: 24),

          const Divider(),

          const SizedBox(height: 16),

          // -------------------------------------------------------------------
          // Conversion
          // -------------------------------------------------------------------
          const Text(
            'Conversion',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: selectOutput,
            child: const Text('Select Output'),
          ),

          if (outputDirectory != null)
            Text(outputDirectory!.path, style: const TextStyle(fontSize: 12)),

          const SizedBox(height: 8),

          _dropdown('Container', container, NyxContainer.values, (value) {
            setState(() {
              container = value;
            });
          }),

          _dropdown('Video Codec', videoCodec, NyxVideoCodec.values, (value) {
            setState(() {
              videoCodec = value;
            });
          }),

          _dropdown('Audio Codec', audioCodec, NyxAudioCodec.values, (value) {
            setState(() {
              audioCodec = value;
            });
          }),

          TextField(
            controller: audioBitrateController,
            decoration: const InputDecoration(
              labelText: 'Audio bitrate (kbps)',
            ),
            keyboardType: TextInputType.number,
          ),

          TextField(
            controller: videoBitrateController,
            decoration: const InputDecoration(
              labelText: 'Video bitrate (Mbps)',
            ),
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 20),

          if (converting) ...[
            LinearProgressIndicator(value: progress / 100),

            const SizedBox(height: 8),

            Text('${progress.toStringAsFixed(1)}%'),

            Text('FPS: ${fps?.toStringAsFixed(2) ?? "--"}'),

            Text('Speed: ${speed?.toStringAsFixed(2) ?? "--"}x'),

            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: cancel,
              icon: const Icon(Icons.cancel),
              label: const Text('Cancel'),
            ),
          ] else ...[
            ElevatedButton.icon(
              onPressed: inputPath == null ? null : convert,
              icon: const Icon(Icons.sync),
              label: const Text('Convert'),
            ),
          ],

          if (completed) ...[
            const SizedBox(height: 12),

            const Text(
              'Conversion completed',
              style: TextStyle(color: Colors.green, fontSize: 18),
            ),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
