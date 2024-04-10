import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;

  const CustomTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }
}
