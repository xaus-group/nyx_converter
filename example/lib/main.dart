import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nyx_converter/nyx_converter.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const NyxExampleApp());
}

class NyxExampleApp extends StatelessWidget {
  const NyxExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nyx Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const NyxHomePage(),
    );
  }
}

class NyxHomePage extends StatefulWidget {
  const NyxHomePage({super.key});

  @override
  State<NyxHomePage> createState() => _NyxHomePageState();
}

class _NyxHomePageState extends State<NyxHomePage> {
  String? _inputPath;
  Directory? _outputDirectory;

  NyxMediaInfo? _mediaInfo;
  Uint8List? _thumbnail;

  NyxContainer _container = NyxContainer.mp4;
  NyxVideoCodec _videoCodec = NyxVideoCodec.h264;
  NyxAudioCodec _audioCodec = NyxAudioCodec.aac;
  NyxSize _size = NyxSize.w1920h1080;
  NyxSampleRate _sampleRate = NyxSampleRate.hz48000;
  NyxChannelLayout _channelLayout = NyxChannelLayout.stereo;

  final _audioBitrateController = TextEditingController(text: '192');
  final _videoBitrateController = TextEditingController(text: '5');

  bool _loadingInfo = false;
  bool _loadingThumbnail = false;
  bool _converting = false;

  double _progress = 0;
  double? _fps;
  double? _speed;

  @override
  void dispose() {
    _audioBitrateController.dispose();
    _videoBitrateController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
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
      _inputPath = path;
      _mediaInfo = null;
      _thumbnail = null;
      _loadingInfo = true;
      _loadingThumbnail = true;
      _progress = 0;
      _fps = null;
      _speed = null;
    });

    await Future.wait([_loadMediaInfo(path), _loadThumbnail(path)]);
  }

  Future<void> _loadMediaInfo(String path) async {
    try {
      final info = await NyxConverter.getMediaInfo(path);

      if (!mounted) {
        return;
      }

      setState(() {
        _mediaInfo = info;
        _loadingInfo = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loadingInfo = false;
      });

      _showError('Unable to read media information.\n\n$e');
    }
  }

  Future<void> _loadThumbnail(String path) async {
    try {
      final bytes = await NyxConverter.getThumbnail(path);

      if (!mounted) {
        return;
      }

      setState(() {
        _thumbnail = bytes;
        _loadingThumbnail = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _thumbnail = null;
        _loadingThumbnail = false;
      });

      debugPrint('Thumbnail error: $e');
    }
  }

  Future<void> _selectOutputDirectory() async {
    final directory = await getDownloadsDirectory();

    if (!mounted) {
      return;
    }

    if (directory == null) {
      _showError('Downloads directory is not available.');
      return;
    }

    setState(() {
      _outputDirectory = directory;
    });
  }

  Future<void> _convert() async {
    final inputPath = _inputPath;

    if (inputPath == null) {
      _showError('Please select a media file first.');
      return;
    }

    final directory = _outputDirectory ?? await getDownloadsDirectory();

    if (directory == null) {
      _showError('Output directory is not available.');
      return;
    }

    final audioBitrate = int.tryParse(_audioBitrateController.text);

    final videoBitrate = int.tryParse(_videoBitrateController.text);

    setState(() {
      _converting = true;
      _progress = 0;
      _fps = null;
      _speed = null;
    });

    try {
      await NyxConverter.convertTo(
        inputPath,
        directory.path,
        container: _container,
        videoCodec: _videoCodec,
        audioCodec: _audioCodec,
        size: _size,
        sampleRate: _sampleRate,
        channelLayout: _channelLayout,
        audioBitrate: audioBitrate,
        videoBitrate: videoBitrate,
        fileName: 'nyx_output',
        execution:
            (
              NyxStatus status, {
              double? progress,
              double? fps,
              double? speed,
              String? errorMessage,
            }) {
              if (!mounted) {
                return;
              }

              switch (status) {
                case NyxStatus.running:
                  setState(() {
                    _progress = progress ?? 0;
                    _fps = fps;
                    _speed = speed;
                  });

                case NyxStatus.completed:
                  setState(() {
                    _converting = false;
                    _progress = 100;
                  });

                  _showMessage('Conversion completed.');

                case NyxStatus.failed:
                  setState(() {
                    _converting = false;
                  });

                  _showError(errorMessage ?? 'Conversion failed.');

                case NyxStatus.cancel:
                  setState(() {
                    _converting = false;
                  });
              }
            },
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _converting = false;
      });

      _showError(e.toString());
    }
  }

  void _cancel() {
    NyxConverter.kill();

    setState(() {
      _converting = false;
    });
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nyx Converter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFileSection(),
          if (_inputPath != null) ...[
            const SizedBox(height: 16),
            _buildPreview(),
            const SizedBox(height: 16),
            _buildMediaInfo(),
            const SizedBox(height: 24),
            _buildConversionSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildFileSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Media File',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _converting ? null : _pickFile,
                icon: const Icon(Icons.folder_open),
                label: const Text('Select Media File'),
              ),
            ),
            if (_inputPath != null) ...[
              const SizedBox(height: 12),
              Text(_inputPath!, style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (_loadingThumbnail) {
      return const Card(
        child: SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_thumbnail == null) {
      return const SizedBox.shrink();
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.memory(_thumbnail!, fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildMediaInfo() {
    if (_loadingInfo) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final info = _mediaInfo;

    if (info == null) {
      return const SizedBox.shrink();
    }

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
            _infoRow('File', info.fileName),
            _infoRow('Format', info.format ?? '--'),
            _infoRow('Duration', _formatDuration(info.duration)),
            _infoRow('Size', _formatFileSize(info.size)),
            _infoRow('Type', _mediaType(info)),
            if (info.video != null) ...[
              const Divider(height: 24),
              const Text(
                'Video',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _infoRow('Codec', info.video!.codec ?? '--'),
              _infoRow(
                'Resolution',
                _resolution(info.video!.width, info.video!.height),
              ),
              _infoRow('FPS', info.video!.fps?.toStringAsFixed(2) ?? '--'),
              _infoRow('Bitrate', _formatBitrate(info.video!.bitrate)),
            ],
            if (info.audio != null) ...[
              const Divider(height: 24),
              const Text(
                'Audio',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _infoRow('Codec', info.audio!.codec ?? '--'),
              _infoRow('Bitrate', _formatBitrate(info.audio!.bitrate)),
              _infoRow(
                'Sample rate',
                info.audio!.sampleRate != null
                    ? '${info.audio!.sampleRate} Hz'
                    : '--',
              ),
              _infoRow('Channels', info.audio!.channels?.toString() ?? '--'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConversionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Conversion',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _dropdown(
              label: 'Container',
              value: _container,
              values: NyxContainer.values,
              title: (value) => value.title,
              onChanged: (value) {
                setState(() => _container = value);
              },
            ),
            _dropdown(
              label: 'Video Codec',
              value: _videoCodec,
              values: NyxVideoCodec.values,
              title: (value) => value.title,
              onChanged: (value) {
                setState(() => _videoCodec = value);
              },
            ),
            _dropdown(
              label: 'Audio Codec',
              value: _audioCodec,
              values: NyxAudioCodec.values,
              title: (value) => value.title,
              onChanged: (value) {
                setState(() => _audioCodec = value);
              },
            ),
            _dropdown(
              label: 'Video Size',
              value: _size,
              values: NyxSize.values,
              title: (value) => value.title,
              onChanged: (value) {
                setState(() => _size = value);
              },
            ),
            _dropdown(
              label: 'Sample Rate',
              value: _sampleRate,
              values: NyxSampleRate.values,
              title: (value) => value.title,
              onChanged: (value) {
                setState(() => _sampleRate = value);
              },
            ),
            _dropdown(
              label: 'Channels',
              value: _channelLayout,
              values: NyxChannelLayout.values,
              title: (value) => value.title,
              onChanged: (value) {
                setState(() => _channelLayout = value);
              },
            ),
            TextField(
              controller: _videoBitrateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Video bitrate',
                suffixText: 'Mbps',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _audioBitrateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Audio bitrate',
                suffixText: 'kbps',
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _converting ? null : _selectOutputDirectory,
              icon: const Icon(Icons.folder),
              label: const Text('Select Output Directory'),
            ),
            if (_outputDirectory != null) ...[
              const SizedBox(height: 8),
              Text(
                _outputDirectory!.path,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 20),
            if (_converting) _buildProgress(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _converting ? _cancel : _convert,
                icon: Icon(_converting ? Icons.cancel_outlined : Icons.sync),
                label: Text(_converting ? 'Cancel' : 'Convert'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(value: _progress / 100),
          const SizedBox(height: 8),
          Text('${_progress.toStringAsFixed(1)}%'),
          if (_fps != null) Text('FPS: ${_fps!.toStringAsFixed(2)}'),
          if (_speed != null) Text('Speed: ${_speed!.toStringAsFixed(2)}x'),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<T> values,
    required String Function(T value) title,
    required ValueChanged<T> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: values
            .map(
              (item) =>
                  DropdownMenuItem<T>(value: item, child: Text(title(item))),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value ?? '--')),
        ],
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
}
