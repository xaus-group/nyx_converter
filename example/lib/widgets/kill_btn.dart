import 'package:flutter/material.dart';

class KillBtn extends StatelessWidget {
  final Function() onClick;
  const KillBtn(this.onClick, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () => onClick(),
        style: TextButton.styleFrom(
            backgroundColor: Colors.grey[200], foregroundColor: Colors.black),
        icon: const Icon(Icons.cancel_outlined),
        label: const Text('Cancel process'));
  }
}
