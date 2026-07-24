import 'dart:io';

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
  String? inputPath;

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

  Future<void> pickInput() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result?.files.single.path != null) {
      setState(() {
        inputPath = result!.files.single.path;
      });
    }
  }

  Future<void> selectOutput() async {
    final directory = await getDownloadsDirectory();

    setState(() {
      outputDirectory = directory;
    });
  }

  Future<void> convert() async {
    if (inputPath == null) {
      _showError('Please select a video file');
      return;
    }

    final directory = outputDirectory ?? await getDownloadsDirectory();

    if (directory == null) {
      _showError('Output directory not found');
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
              if (!mounted) return;

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

                _showError(errorMessage ?? 'Conversion failed');
              }

              if (status == NyxStatus.cancel) {
                setState(() {
                  converting = false;
                });
              }
            },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        converting = false;
      });

      _showError(e.toString());
    }
  }

  void cancel() {
    NyxConverter.kill();

    setState(() {
      converting = false;
    });
  }

  void _showError(String message) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nyx Converter')),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          ElevatedButton(
            onPressed: pickInput,
            child: const Text('Select Video'),
          ),

          if (inputPath != null)
            Text(inputPath!, style: const TextStyle(fontSize: 12)),

          ElevatedButton(
            onPressed: selectOutput,
            child: const Text('Select Output'),
          ),

          if (outputDirectory != null) Text(outputDirectory!.path),

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

            Text('${progress.toStringAsFixed(1)}%'),

            Text('FPS: ${fps ?? "--"}'),

            Text('Speed: ${speed ?? "--"}x'),

            ElevatedButton(onPressed: cancel, child: const Text('Cancel')),
          ] else
            ElevatedButton(onPressed: convert, child: const Text('Convert')),

          if (completed)
            const Text(
              'Conversion completed',
              style: TextStyle(color: Colors.green, fontSize: 18),
            ),
        ],
      ),
    );
  }

  Widget _dropdown<T>(
    String title,
    T value,
    List<T> items,
    ValueChanged<T> onChanged,
  ) {
    return DropdownButton<T>(
      value: value,

      items: items
          .map(
            (item) => DropdownMenuItem(
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
}
