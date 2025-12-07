import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nyx_converter/nyx_converter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MaterialApp(home: NyxExampleApp()));
}

class NyxExampleApp extends StatefulWidget {
  const NyxExampleApp({super.key});

  @override
  State<NyxExampleApp> createState() => _NyxExampleAppState();
}

class _NyxExampleAppState extends State<NyxExampleApp> {
  String? inputPath;
  Directory? outputDir;

  NyxContainer container = NyxContainer.mp4;
  NyxVideoCodec vCodec = NyxVideoCodec.h264;
  NyxAudioCodec aCodec = NyxAudioCodec.aac;

  final audioBitrate = TextEditingController(text: "128000");
  final videoBitrate = TextEditingController(text: "2000000");

  double progress = 0;
  double? fps;
  double? speed;
  bool isConverting = false;
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> pickInput() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) setState(() => inputPath = result.files.single.path);
  }

  Future<void> selectOutputDir() async {
    outputDir = await getDownloadsDirectory();
    setState(() {});
  }

  Future<void> startConvert() async {
    if (inputPath == null) {
      _alert("Please select an input file");
      return;
    }

    final out = outputDir ?? (await getDownloadsDirectory())!;
    String fileName = Random().nextInt(999999).toString();

    setState(() {
      progress = 0;
      fps = null;
      speed = null;
      isConverting = true;
      isDone = false;
    });

    await NyxConverter.convertTo(
      inputPath!,
      out.path,
      container: container,
      videoCodec: vCodec,
      audioCodec: aCodec,
      audioBitrate: int.tryParse(audioBitrate.text),
      videoBitrate: int.tryParse(videoBitrate.text),
      fileName: fileName,
      debugMode: true,
      execution:
          (
            status, {
            String? errorMessage,
            double? progress,
            double? fps,
            double? speed,
          }) {
            if (status == NyxStatus.running) {
              setState(() {
                this.progress = progress ?? 0;
                this.fps = fps;
                this.speed = speed;
              });
            } else if (status == NyxStatus.completed) {
              setState(() {
                isConverting = false;
                isDone = true;
              });
            } else if (status == NyxStatus.failed) {
              setState(() => isConverting = false);
              _alert(errorMessage ?? "Something went wrong");
            } else if (status == NyxStatus.cancel) {
              setState(() => isConverting = false);
            }
          },
    );
  }

  void _alert(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nyx Converter"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Input File
          ElevatedButton(
            onPressed: pickInput,
            child: const Text("Select Input File"),
          ),
          if (inputPath != null)
            Text("Input: $inputPath", style: const TextStyle(fontSize: 12)),

          const SizedBox(height: 20),

          // Output directory
          ElevatedButton(
            onPressed: selectOutputDir,
            child: const Text("Select Output Directory"),
          ),
          if (outputDir != null)
            Text(
              "Output: ${outputDir!.path}",
              style: const TextStyle(fontSize: 12),
            ),

          const SizedBox(height: 20),

          // Container dropdown
          _dropdown<NyxContainer>(
            label: "Container",
            value: container,
            items: NyxContainer.values,
            onChanged: (v) => setState(() => container = v!),
          ),

          // Video codec dropdown
          _dropdown<NyxVideoCodec>(
            label: "Video Codec",
            value: vCodec,
            items: NyxVideoCodec.values,
            onChanged: (v) => setState(() => vCodec = v!),
          ),

          // Audio codec dropdown
          _dropdown<NyxAudioCodec>(
            label: "Audio Codec",
            value: aCodec,
            items: NyxAudioCodec.values,
            onChanged: (v) => setState(() => aCodec = v!),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: audioBitrate,
            decoration: const InputDecoration(labelText: "Audio Bitrate (bps)"),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: videoBitrate,
            decoration: const InputDecoration(labelText: "Video Bitrate (bps)"),
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 20),

          // Progress Area
          if (isConverting) ...[
            LinearProgressIndicator(value: progress / 100),
            const SizedBox(height: 8),
            Text("Progress: ${progress.toStringAsFixed(1)}%"),
            Text("FPS: ${fps?.toStringAsFixed(2) ?? "--"}"),
            Text("Speed: ${speed?.toStringAsFixed(2) ?? "--"}x"),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => NyxConverter.kill(),
              child: const Text("Cancel"),
            ),
          ],

          if (!isConverting)
            ElevatedButton(
              onPressed: startConvert,
              child: const Text("Start Conversion"),
            ),

          if (isDone)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Conversion Complete!",
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required Function(T?) onChanged,
  }) {
    return Row(
      children: [
        Text("$label: "),
        const SizedBox(width: 10),
        DropdownButton<T>(
          value: value,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.toString().split('.').last.toUpperCase()),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
