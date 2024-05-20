import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class InfoInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final bool enabled;
  final bool obscureText;
  final TextEditingController controller;

  const InfoInputField({
    super.key,
    required this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.obscureText = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4.0),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          cursorColor: buttonBackgroundColor,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Colors.grey, 
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: buttonBackgroundColor,
                width: 2.0,
              ),
            ),
            hintText: hintText,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          ),
          enabled: enabled,
          obscureText: obscureText,
        ),
      ],
    );
  }
}
