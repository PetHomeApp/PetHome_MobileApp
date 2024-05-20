import 'package:flutter/material.dart';

class DashWidget extends StatelessWidget {
  final Color color;

  const DashWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 4.0,
      color: color,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
    );
  }
}