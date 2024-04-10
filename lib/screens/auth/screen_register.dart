import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/auth/custom_text.dart';
import 'package:pethome_mobileapp/widgets/auth/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailEdititngController =
      TextEditingController();
  final TextEditingController _passwordEdititngController =
      TextEditingController();
  final TextEditingController _repasswordEdititngController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 50.0),
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
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: CustomTextWidget(
                          text: 'TÀI KHOẢN',
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      CustomTextField(
                        controller: _emailEdititngController,
                        hintText: 'Nhập tên đăng nhập...',
                        obscureText: false,
                      ),
                      const SizedBox(height: 20.0),
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: CustomTextWidget(
                          text: 'MẬT KHẨU',
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      CustomTextField(
                        controller: _passwordEdititngController,
                        hintText: 'Nhập mật khẩu...',
                        obscureText: true,
                      ),
                      const SizedBox(height: 20.0),
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: CustomTextWidget(
                          text: 'NHẬP LẠI MẬT KHẨU',
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      CustomTextField(
                        controller: _repasswordEdititngController,
                        hintText: 'Nhập lại mật khẩu...',
                        obscureText: true,
                      ),
                      const SizedBox(height: 40.0),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: buttonBackgroundColor,
                        ),
                        child: InkWell(
                          onTap: () async {},
                          child: const Center(
                            child: Text(
                              'ĐĂNG KÍ',
                              style: TextStyle(
                                color: Colors.white, // Màu chữ
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Đã có tài khoản?",
                              style: TextStyle(fontSize: 16)),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Đăng nhập',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: buttonBackgroundColor,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
