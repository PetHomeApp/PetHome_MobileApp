import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                "lib/assets/pictures/logo_app.png",
                width: 150,
                height: 150,
              ),
            ),
            Center(
              child: Image.asset(
                "lib/assets/pictures/name_app.png",
                width: 150,
                height: 75,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
