import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/screens/auth/screen_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePageScreen extends StatefulWidget {
  const MyHomePageScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageScreenState createState() => _MyHomePageScreenState();
}

class _MyHomePageScreenState extends State<MyHomePageScreen> {
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  _initPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  _resetPrefs() async {
    await sharedPreferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chính'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Xác nhận"),
                      content:
                          const Text("Bạn có chắc chắn muốn đăng xuất không?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Không",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 84, 84, 84))),
                        ),
                        TextButton(
                          onPressed: () {
                            _resetPrefs();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (route) => false,
                            );
                          },
                          child: const Text("Đăng xuất",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 209, 87, 78))),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}
