import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/screens/auth/screen_register.dart';
import 'package:pethome_mobileapp/screens/pets/screen_pet_homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterScreen(),
    );
  }
}
