import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/screens/auth/screen_login.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
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
        title: const Text(
          "Menu",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [gradientStartColor, gradientMidColor, gradientEndColor],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // ignore: avoid_print
                        print('Thông tin cá nhân');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 120.0,
                              height: 120.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3.0,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60.0),
                                  child: Image.network(
                                    'https://via.placeholder.co',
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Image.asset(
                                          'lib/assets/pictures/placeholder_image.png',
                                          fit: BoxFit.cover);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Tên: Nguyễn Văn A',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    softWrap:
                                        true, // enable text to wrap onto the next line
                                  ),
                                  Text(
                                    'ID: 30086f0e-f2bf-4a1c-b579-691a06bd8970',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    softWrap:
                                        true, // enable text to wrap onto the next line
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle 'Tin nhắn' tap
                  },
                  child: const Text('Tin nhắn'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle 'Giỏ hàng' tap
                  },
                  child: const Text('Giỏ hàng'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle 'Đơn hàng của tôi' tap
                  },
                  child: const Text('Đơn hàng của tôi'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle 'Quản lí cửa hàng' tap
                  },
                  child: const Text('Quản lí cửa hàng'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: buttonBackgroundColor,
                ),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Xác nhận"),
                          content: const Text(
                              "Bạn có chắc chắn muốn đăng xuất không?"),
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
                                      builder: (context) =>
                                          const LoginScreen()),
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
                  child: const Center(
                    child: Text(
                      'Đăng xuất',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
