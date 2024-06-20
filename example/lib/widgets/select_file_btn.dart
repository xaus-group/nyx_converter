import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SelectFileBtn extends StatelessWidget {
  final Function(String filePath) file;
  const SelectFileBtn(this.file, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () async {
          _getPermission();

          FilePickerResult? result = await FilePicker.platform.pickFiles();

          if (result != null) {
            file(File(result.files.single.path!).path);
          } else {
            // User canceled the picker
          }
        },
        style: TextButton.styleFrom(
            backgroundColor: Colors.grey[200], foregroundColor: Colors.black),
        icon: const Icon(Icons.file_download_outlined),
        label: const Text('Select Media File'));
  }

  _getPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }
  }
}
