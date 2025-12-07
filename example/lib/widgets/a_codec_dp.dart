import 'package:flutter/material.dart';
import 'package:nyx_converter/nyx_converter.dart';

class ACodecDp extends StatefulWidget {
  final Function(NyxAudioCodec codec) codec;
  const ACodecDp(this.codec, {super.key});

  @override
  State<ACodecDp> createState() => _ACodecDpState();
}

class _ACodecDpState extends State<ACodecDp> {
  String dropdownValue = NyxAudioCodec.aac.command;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Audio Codec:  ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        DropdownButton(
          items: [
            DropdownMenuItem(
              value: 'libmp3lame',
              child: Text(NyxAudioCodec.mp3.name),
            ),
            DropdownMenuItem(value: 'mp2', child: Text(NyxAudioCodec.mp2.name)),
            DropdownMenuItem(
              value: 'wmav2',
              child: Text(NyxAudioCodec.wma.name),
            ),
            DropdownMenuItem(value: 'aac', child: Text(NyxAudioCodec.aac.name)),
            DropdownMenuItem(
              value: 'libvorbis',
              child: Text(NyxAudioCodec.ogg.name),
            ),
            DropdownMenuItem(
              value: 'flac',
              child: Text(NyxAudioCodec.flac.name),
            ),
            DropdownMenuItem(
              value: 'alas',
              child: Text(NyxAudioCodec.alac.name),
            ),
            DropdownMenuItem(value: 'dsd', child: Text(NyxAudioCodec.dsd.name)),
          ],
          value: dropdownValue,
          onChanged: (value) async {
            NyxAudioCodec codec;
            switch (value) {
              case 'libmp3lame':
                codec = NyxAudioCodec.mp3;

                break;
              case 'mp2':
                codec = NyxAudioCodec.mp2;

                break;
              case 'wmav2':
                codec = NyxAudioCodec.wma;
                break;
              case 'aac':
                codec = NyxAudioCodec.aac;
                break;
              case 'libvorbis':
                codec = NyxAudioCodec.ogg;
                break;
              case 'flac':
                codec = NyxAudioCodec.flac;
                break;
              case 'alas':
                codec = NyxAudioCodec.alac;
                break;
              case 'dsd':
                codec = NyxAudioCodec.dsd;
                break;
              default:
                codec = NyxAudioCodec.aac;
            }

            setState(() {
              dropdownValue = value!;
            });

            widget.codec(codec);
          },
          dropdownColor: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
      ],
    );
  }
}
