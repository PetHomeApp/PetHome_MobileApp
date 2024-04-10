import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/auth/custom_text.dart';
import 'package:pethome_mobileapp/widgets/auth/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const LoginScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEdititngController =
      TextEditingController();
  final TextEditingController _passwordEdititngController =
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                            color: buttonBackgroundColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
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
                            'ĐĂNG NHẬP',
                            style: TextStyle(
                              color: Colors.white, // Màu chữ
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    const Text(
                      'Hoặc tiếp tục với:',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: buttonBackgroundColor,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'lib/assets/pictures/icon_facebook.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 50),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: buttonBackgroundColor,
                                width: 1.0,
                              ),
                              color: null,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'lib/assets/pictures/icon_google.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Chưa có tài khoản?",
                            style: TextStyle(fontSize: 16)),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Đăng kí',
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
          ),
        ),
      ),
    );
  }
}
