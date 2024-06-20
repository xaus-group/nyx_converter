import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SaveTo extends StatefulWidget {
  final Function(Directory? directory) directory;
  const SaveTo(this.directory, {super.key});

  @override
  State<SaveTo> createState() => _SaveToState();
}

class _SaveToState extends State<SaveTo> {
  String dropdownValue = 'DownloadsDirectory';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Save To:  ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        DropdownButton(
            items: const [
              DropdownMenuItem(
                  value: 'TemporaryDirectory',
                  child: Text('Temporary Directory')),
              DropdownMenuItem(
                  value: 'AppDocumentsDirectory',
                  child: Text('App Documents Directory')),
              DropdownMenuItem(
                value: 'DownloadsDirectory',
                child: Text('Downloads Directory'),
              )
            ],
            value: dropdownValue,
            onChanged: (value) async {
              Directory? path;
              switch (value) {
                case 'TemporaryDirectory':
                  path = await getTemporaryDirectory();

                  break;
                case 'AppDocumentsDirectory':
                  path = await getApplicationDocumentsDirectory();

                  break;
                case 'DownloadsDirectory':
                  path = await getDownloadsDirectory();
                  break;
                default:
                  path = await getDownloadsDirectory();
              }
              setState(() {
                dropdownValue = value!;
              });
              widget.directory(path);
            },
            dropdownColor: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            icon: const Icon(Icons.file_copy)),
      ],
    );
  }
}
