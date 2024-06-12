import 'package:flutter/material.dart';
import 'package:nyx_converter/nyx_converter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    _getPermission();
    return const Scaffold();
  }

  _getPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    } else {
      NyxConverter.convertTo(
        '/storage/emulated/0/Movies/selin.mp4',
        '/storage/emulated/0/Music',
        container: NyxContainer.mp3,
        debugMode: true,
        fileName: 'selinaudio',
      );
    }
  }
}
