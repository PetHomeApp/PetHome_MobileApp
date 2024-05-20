import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  final Color color;

  const CircleWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.0,
      height: 10.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}