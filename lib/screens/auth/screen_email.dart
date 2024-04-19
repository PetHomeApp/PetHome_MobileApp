import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/screens/auth/screen_otp.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/auth/custom_textfield.dart';

class EmailScreeen extends StatefulWidget {
  const EmailScreeen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmailScreeenState createState() => _EmailScreeenState();
}

class _EmailScreeenState extends State<EmailScreeen> {
  final TextEditingController _emailEdititngController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          "Bước 1: Nhập Email",
          style: TextStyle(
              color: buttonBackgroundColor,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 25.0),
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
                    const Text(
                      'Nhập email của bạn',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Thêm email của bạn. Chúng tôi sẽ gửi cho bạn mã xác minh để chúng tôi biết bạn là thật. Chúng tôi sẽ sử dụng email này làm tên đăng nhập cho tài khoản của bạn.",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CustomTextField(
                      controller: _emailEdititngController,
                      hintText: 'Nhập email...',
                      obscureText: false,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: buttonBackgroundColor,
                      ),
                      child: InkWell(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                  email: _emailEdititngController.text),
                            ),
                          );
                        },
                        child: const Center(
                          child: Text(
                            'Gửi mã xác nhận',
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
          ),
        ),
      ),
    );
  }
}
