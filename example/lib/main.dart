import 'dart:io';
import 'dart:math';

import 'package:example/widgets/a_codec_dp.dart';
import 'package:example/widgets/container_dp.dart';
import 'package:example/widgets/convert_btn.dart';
import 'package:example/widgets/kill_btn.dart';
import 'package:example/widgets/save_to.dart';
import 'package:example/widgets/select_file_btn.dart';
import 'package:example/widgets/v_codec_dp.dart';
import 'package:flutter/material.dart';
import 'package:nyx_converter/nyx_converter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Nyx Converter Example App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? inputFilePath;
  Directory? outputPath;
  NyxContainer? container;
  NyxVideoCodec? videoCodec;
  NyxAudioCodec? audioCodec;
  bool isLoading = false;
  bool isDone = false;
  bool isCanceled = false;

  final TextEditingController _audioBitrateController = TextEditingController();
  final TextEditingController _videoBitrateController = TextEditingController();
  String _audioErrorMessage = '';
  String _videoErrorMessage = '';
  void _parseBitrate() {
    setState(() {
      _audioErrorMessage = '';
      _videoErrorMessage = '';
    });

    try {
      int.parse(_audioBitrateController.text);
    } catch (e) {
      setState(() {
        _audioErrorMessage = 'Please enter a valid integer for bitrate.';
      });
    }
    try {
      int.parse(_videoBitrateController.text);
    } catch (e) {
      setState(() {
        _videoErrorMessage = 'Please enter a valid integer for bitrate.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _getPermission();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Nyx Converter Example App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // select the file btn
              SelectFileBtn((String filePath) => setState(() {
                    inputFilePath = filePath;
                  })),
              // text to display selected file path
              inputFilePath != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Text(inputFilePath!),
                    )
                  : Container(),
              // save to dropdown
              SaveTo((Directory? directory) => setState(() {
                    outputPath = directory;
                  })),
              // text to display selected directory path
              outputPath != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Text(outputPath!.path.toString()),
                    )
                  : Container(),
              // container dropdown
              ContainerDP((cntnr) {
                container = cntnr;
              }),
              // video codec dropdown
              VCodecDp((codec) {
                videoCodec = codec;
              }),
              // audio codec dropdown
              ACodecDp((codec) {
                audioCodec = codec;
              }),
              // bitrate text field
              TextField(
                controller: _audioBitrateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Audio Bitrate',
                  errorText:
                      _audioErrorMessage.isNotEmpty ? _audioErrorMessage : null,
                ),
              ),
              TextField(
                controller: _videoBitrateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Video Bitrate',
                  errorText:
                      _videoErrorMessage.isNotEmpty ? _audioErrorMessage : null,
                ),
              ),
              // convert to btn
              ConvertBtn(isLoading, () {
                // check bitrate validation
                _parseBitrate();

                if (_audioErrorMessage.isEmpty && _videoErrorMessage.isEmpty) {
                  _startConvert(
                    inputFilePath,
                    outputPath,
                    container,
                    videoCodec,
                    audioCodec,
                    int.parse(_audioBitrateController.text),
                    int.parse(_videoBitrateController.text),
                  );
                }
              }),
              // kill btn
              KillBtn(
                () => NyxConverter.kill(),
              ),
              // is done text
              isDone == true
                  ? const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Text('Done'),
                    )
                  : isCanceled == true
                      ? const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Text('Canceled'),
                        )
                      : Container(),
            ],
          ),
        ));
  }

  _getPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }
  }

  _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        backgroundColor: Colors.white,
        actions: <Widget>[
          TextButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black),
              icon: const Icon(Icons.disabled_by_default_outlined),
              label: const Text('OK')),
        ],
      ),
    );
  }

  _startConvert(
    String? filePath,
    Directory? outputPath,
    NyxContainer? container,
    NyxVideoCodec? vCodec,
    NyxAudioCodec? aCodec,
    int? audioBitrate,
    int? videoBitrate,
  ) async {
    setState(() {
      isLoading = true;
    });
    _getPermission();

    Directory? output = outputPath ?? await getDownloadsDirectory();

    if (inputFilePath == null) {
      _showDialog('Please select input file');
      setState(() {
        isLoading = false;
      });
    }
    String rfilename = Random().nextInt(1000).toString();
    if (outputPath != null && inputFilePath != null) {
      await NyxConverter.convertTo(filePath!, output!.path,
          container: container,
          videoCodec: vCodec,
          audioCodec: aCodec,
          audioBitrate: audioBitrate,
          videoBitrate: videoBitrate,
          fileName: rfilename,
          debugMode: true,
          execution: (String? path, NyxStatus status, {String? errorMessage}) {
        if (status == NyxStatus.failed) {
          setState(() {
            isLoading = false;
          });
          _showDialog(errorMessage ?? 'Something went wrong');
        } else if (status == NyxStatus.completed) {
          String psthn = "${output.path}/$rfilename.avi";

          print('*************$psthn');
          print('*************${File(psthn).existsSync()}');
          setState(() {
            isLoading = false;
            isDone = true;
          });
        } else if (status == NyxStatus.running) {
          setState(() {
            isLoading = true;
            isDone = false;
          });
        } else if (status == NyxStatus.cancel) {
          setState(() {
            isLoading = false;
            isDone = false;
            isCanceled = true;
          });
        } else {
          setState(() {
            isLoading = false;
            isDone = true;
          });
        }
      });
    }
  }
}
