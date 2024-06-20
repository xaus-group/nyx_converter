import 'package:flutter/material.dart';
import 'package:nyx_converter/nyx_converter.dart';

class ContainerDP extends StatefulWidget {
  final Function(NyxContainer container) container;
  const ContainerDP(this.container, {super.key});

  @override
  State<ContainerDP> createState() => _ContainerDPState();
}

class _ContainerDPState extends State<ContainerDP> {
  String dropdownValue = 'avi';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Container:  ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        DropdownButton(
            items: const [
              DropdownMenuItem(value: 'avi', child: Text('AVI')),
              DropdownMenuItem(value: 'mp4', child: Text('MP4')),
              DropdownMenuItem(value: 'mkv', child: Text('MKV')),
              DropdownMenuItem(value: 'mov', child: Text('MOV')),
              DropdownMenuItem(value: 'webm', child: Text('WebM')),
              DropdownMenuItem(value: 'flac', child: Text('FLAC')),
              DropdownMenuItem(value: 'wav', child: Text('WAV')),
              DropdownMenuItem(value: 'ogg', child: Text('OGG')),
              DropdownMenuItem(value: 'aac', child: Text('AAC')),
              DropdownMenuItem(value: 'mp3', child: Text('MP3')),
            ],
            value: dropdownValue,
            onChanged: (value) async {
              NyxContainer container;
              switch (value) {
                case 'avi':
                  container = NyxContainer.avi;

                  break;
                case 'mp4':
                  container = NyxContainer.mp4;

                  break;
                case 'mkv':
                  container = NyxContainer.mkv;
                  break;
                case 'mov':
                  container = NyxContainer.mov;
                  break;
                case 'webm':
                  container = NyxContainer.webM;
                  break;
                case 'flac':
                  container = NyxContainer.flac;
                  break;
                case 'wav':
                  container = NyxContainer.wav;
                  break;
                case 'ogg':
                  container = NyxContainer.ogg;
                  break;
                case 'aac':
                  container = NyxContainer.aac;
                  break;
                case 'mp3':
                  container = NyxContainer.mp3;
                  break;
                default:
                  container = NyxContainer.avi;
              }

              setState(() {
                dropdownValue = value!;
              });

              widget.container(container);
            },
            dropdownColor: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            icon: const Icon(Icons.keyboard_arrow_down_rounded)),
      ],
    );
  }
}
