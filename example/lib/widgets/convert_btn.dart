import 'package:flutter/material.dart';

class ConvertBtn extends StatelessWidget {
  final bool isLoading;
  final Function() onClick;
  const ConvertBtn(this.isLoading, this.onClick, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () => onClick(),
        style: TextButton.styleFrom(
            backgroundColor: Colors.grey[200], foregroundColor: Colors.black),
        icon: const Icon(Icons.all_inclusive_rounded),
        label: isLoading
            ? const SizedBox(
                height: 10,
                width: 10,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2.0,
                ),
              )
            : const Text('Convert'));
  }
}
