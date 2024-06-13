import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/screens/auth/screen_login.dart';
import 'package:pethome_mobileapp/services/api/auth_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/auth/custom_text.dart';
import 'package:pethome_mobileapp/widgets/auth/custom_textfield.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// ignore: must_be_immutable
class ForgotPasswordScreen extends StatefulWidget {
  final String email;
  String expiredAt;
  String token;

  ForgotPasswordScreen(
      {super.key,
      required this.email,
      required this.expiredAt,
      required this.token});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
          "Nhập lại mật khẩu mới",
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
                          text: 'MẬT KHẨU MỚI',
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
                          text: 'NHẬP LẠI MẬT KHẨU MỚI',
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
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: buttonBackgroundColor,
                        ),
                        child: InkWell(
                          onTap: () async {
                            DateTime now = DateTime.now();
                            DateTime expiredAt =
                                DateTime.parse(widget.expiredAt).toLocal();
                            if (_passwordEdititngController.text == "" ||
                                _repasswordEdititngController.text == "") {
                              showTopSnackBar(
                                // ignore: use_build_context_synchronously
                                Overlay.of(context),
                                const CustomSnackBar.error(
                                  message: 'Vui lòng nhập đầy đủ thông tin!',
                                ),
                                displayDuration: const Duration(seconds: 0),
                              );
                            } else if (_passwordEdititngController.text !=
                                _repasswordEdititngController.text) {
                              showTopSnackBar(
                                // ignore: use_build_context_synchronously
                                Overlay.of(context),
                                const CustomSnackBar.error(
                                  message:
                                      'Mật khẩu nhập lại không trùng khớp!',
                                ),
                                displayDuration: const Duration(seconds: 0),
                              );
                            } else if (now.isAfter(expiredAt)) {
                              showTopSnackBar(
                                // ignore: use_build_context_synchronously
                                Overlay.of(context),
                                const CustomSnackBar.error(
                                  message:
                                      'Mã xác nhận đã hết hạn! Vui lòng quay lại trang OTP để nhận mã mới!',
                                ),
                                displayDuration: const Duration(seconds: 0),
                              );
                            } else {
                              var dataResponse = await AuthApi().resetPassword(
                                  _passwordEdititngController.text,
                                  widget.token);

                              if (dataResponse['isSuccess'] == true) {
                                showTopSnackBar(
                                  // ignore: use_build_context_synchronously
                                  Overlay.of(context),
                                  const CustomSnackBar.success(
                                    message: 'Thay đổi mật khẩu thành công!',
                                  ),
                                  displayDuration: const Duration(seconds: 0),
                                );
                                Navigator.pushAndRemoveUntil(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (route) => false,
                                );
                              } else {
                                showTopSnackBar(
                                  // ignore: use_build_context_synchronously
                                  Overlay.of(context),
                                  const CustomSnackBar.error(
                                    message: 'Thay đổi mật khẩu thất bại!',
                                  ),
                                  displayDuration: const Duration(seconds: 0),
                                );
                              }
                            }
                          },
                          child: const Center(
                            child: Text(
                              'XÁC NHẬN',
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
