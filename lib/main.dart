import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/screens/auth/screen_login.dart';
import 'package:pethome_mobileapp/screens/screen_loading.dart';
import 'package:pethome_mobileapp/screens/screen_homepage.dart';
import 'package:pethome_mobileapp/services/api/auth_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences sharedPreferences;
  bool isLogin = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  _initPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var dataResponse = await AuthApi().authorize();

    if (dataResponse['isSuccess'] == true) {
      setState(() {
        isLoading = false;
        isLogin = true;
      });
    } else {
      setState(() {
        isLoading = false;
        isLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: isLoading
          ? const LoadingScreen()
          : isLogin
              ? const MainScreen(initialIndex: 0,)
              : const LoginScreen(),
    );
  }
}
