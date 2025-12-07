import 'package:flutter/material.dart';
import 'package:nyx_converter/nyx_converter.dart';

class VCodecDp extends StatefulWidget {
  final Function(NyxVideoCodec codec) codec;
  const VCodecDp(this.codec, {super.key});

  @override
  State<VCodecDp> createState() => _VCodecDpState();
}

class _VCodecDpState extends State<VCodecDp> {
  String dropdownValue = NyxVideoCodec.h264.command;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Video Codec:  ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        DropdownButton(
          items: [
            DropdownMenuItem(
              value: 'libx264',
              child: Text(NyxVideoCodec.h264.name),
            ),
            DropdownMenuItem(
              value: 'libx265',
              child: Text(NyxVideoCodec.h265.name),
            ),
            DropdownMenuItem(
              value: 'libxvid',
              child: Text(NyxVideoCodec.xvid.name),
            ),
            DropdownMenuItem(
              value: 'libvpx',
              child: Text(NyxVideoCodec.vp8.name),
            ),
            DropdownMenuItem(
              value: 'libvpx-vp9',
              child: Text(NyxVideoCodec.vp9.name),
            ),
            DropdownMenuItem(
              value: 'libaom-av1',
              child: Text(NyxVideoCodec.av1.name),
            ),
            DropdownMenuItem(
              value: 'mpeg4',
              child: Text(NyxVideoCodec.mpeg4.name),
            ),
            DropdownMenuItem(
              value: 'mpeg2video',
              child: Text(NyxVideoCodec.mpeg2.name),
            ),
          ],
          value: dropdownValue,
          onChanged: (String? value) async {
            NyxVideoCodec codec;

            switch (value) {
              case 'libx264':
                codec = NyxVideoCodec.h264;

                break;
              case 'libx265':
                codec = NyxVideoCodec.h265;

                break;
              case 'libxvid':
                codec = NyxVideoCodec.xvid;
                break;
              case 'libvpx':
                codec = NyxVideoCodec.vp8;
                break;
              case 'libvpx-vp9':
                codec = NyxVideoCodec.vp9;
                break;
              case 'libaom-av1':
                codec = NyxVideoCodec.av1;
                break;
              case 'mpeg4':
                codec = NyxVideoCodec.mpeg4;
                break;
              case 'mpeg2video':
                codec = NyxVideoCodec.mpeg2;
                break;
              default:
                codec = NyxVideoCodec.h264;
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
