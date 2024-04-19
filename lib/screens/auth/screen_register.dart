import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/auth/custom_text.dart';
import 'package:pethome_mobileapp/widgets/auth/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  final String email;
  // ignore: use_super_parameters
  const RegisterScreen({Key? key, required this.email}) : super(key: key);

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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Bước 3: Hoàn tất thông tin",
          style: TextStyle(
              color: buttonBackgroundColor,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10.0),
                Center(
                  child: Image.asset(
                    "lib/assets/pictures/logo_app.png",
                    width: 150,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: CustomTextWidget(
                          text: 'TÀI KHOẢN (EMAIL)',
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      CustomTextField(
                        controller: _emailEdititngController,
                        hintText: widget.email,
                        obscureText: false,
                        readOnly: true,
                      ),
                      const SizedBox(height: 20.0),
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: CustomTextWidget(
                          text: 'TÊN NGƯỜI DÙNG',
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      CustomTextField(
                        controller: _emailEdititngController,
                        hintText: 'Nhập tên người dùng...',
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
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
