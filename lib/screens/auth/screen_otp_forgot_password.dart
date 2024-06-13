import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:pethome_mobileapp/screens/auth/screen_forgot_password.dart';
import 'package:pethome_mobileapp/services/api/auth_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// ignore: must_be_immutable
class ForgotPasswordOtpScreen extends StatefulWidget {
  final String email;
  String expiredAt;
  String token;

  ForgotPasswordOtpScreen(
      {super.key,
      required this.email,
      required this.expiredAt,
      required this.token});

  @override
  State<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  late Timer _timer;
  int _secondsRemaining = 59;
  bool _buttonEnabled = true;

  List<TextEditingController?> otpController = [];

  @override
  void initState() {
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          _buttonEnabled = true;
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _secondsRemaining = 60;
      _buttonEnabled = false;
      _startTimer();
    });
  }

  String getOTP() {
    String otp = '';
    for (int i = 0; i < otpController.length; i++) {
      otp += otpController[i]!.text;
    }
    return otp;
  }

  @override
  void dispose() {
    super.dispose();
  }

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
          "Xác nhận OTP",
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
                      'Xác thực',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Nhập mã OTP được gửi đến email của bạn",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    OtpTextField(
                      textStyle: const TextStyle(
                          fontSize: 18,
                          color: buttonBackgroundColor,
                          fontWeight: FontWeight.bold),
                      numberOfFields: 6,
                      borderColor: buttonBackgroundColor,
                      focusedBorderColor: buttonBackgroundColor,
                      handleControllers: (controllers) {
                        otpController = controllers;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: buttonBackgroundColor,
                      ),
                      child: InkWell(
                        onTap: () async {
                          String otp = getOTP();
                          DateTime now = DateTime.now();
                          DateTime expiredAt =
                              DateTime.parse(widget.expiredAt).toLocal();
                          if (otp.length < 6) {
                            showTopSnackBar(
                              // ignore: use_build_context_synchronously
                              Overlay.of(context),
                              const CustomSnackBar.error(
                                message: 'Vui lòng nhập đủ 6 số OTP',
                              ),
                              displayDuration: const Duration(seconds: 0),
                            );
                          } else if (now.isAfter(expiredAt)) {
                            showTopSnackBar(
                              // ignore: use_build_context_synchronously
                              Overlay.of(context),
                              const CustomSnackBar.error(
                                message: 'Mã OTP đã hết hạn! Vui lòng thử lại!',
                              ),
                              displayDuration: const Duration(seconds: 0),
                            );
                          }
                          else {
                            var dataResponse =
                                await AuthApi().verifyOTPForgotPassword(otp, widget.token);
                            if (dataResponse['isSuccess'] == true) {
                              showTopSnackBar(
                                // ignore: use_build_context_synchronously
                                Overlay.of(context),
                                const CustomSnackBar.success(
                                  message: 'Xác thực thành công!',
                                ),
                                displayDuration: const Duration(seconds: 0),
                              );
                              print(dataResponse['expiredAt'].toString());
                              print(dataResponse['token'].toString());
                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen(
                                    email: widget.email,
                                    expiredAt: dataResponse['expiredAt'].toString(),
                                    token: dataResponse['token'].toString(),
                                  ),
                                ),
                              );
                            } else if (dataResponse['error'] ==
                                'Invalid code') {
                              showTopSnackBar(
                                // ignore: use_build_context_synchronously
                                Overlay.of(context),
                                const CustomSnackBar.error(
                                  message: 'Mã OTP không trùng khớp!',
                                ),
                                displayDuration: const Duration(seconds: 0),
                              );
                            } else {
                              showTopSnackBar(
                                // ignore: use_build_context_synchronously
                                Overlay.of(context),
                                const CustomSnackBar.error(
                                  message: 'Có lỗi xảy ra! Vui lòng thử lại!',
                                ),
                                displayDuration: const Duration(seconds: 0),
                              );
                            }
                          }
                        },
                        child: const Center(
                          child: Text(
                            'Xác thực OTP',
                            style: TextStyle(
                              color: Colors.white, // Màu chữ
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "Bạn không nhận được mã OTP?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: _buttonEnabled
                          ? () async {
                              _resetTimer();
                              var dataResponse =
                                  await AuthApi().sendOTPForgotPassword(widget.email);
                              if (dataResponse['isSuccess'] == true) {
                                showTopSnackBar(
                                  // ignore: use_build_context_synchronously
                                  Overlay.of(context),
                                  const CustomSnackBar.success(
                                    message: 'Đã gửi mã OTP',
                                  ),
                                  displayDuration: const Duration(seconds: 0),
                                );
                                widget.token = dataResponse['token'].toString();
                                widget.expiredAt =
                                    dataResponse['expiredAt'].toString();
                              } else {
                                showTopSnackBar(
                                  // ignore: use_build_context_synchronously
                                  Overlay.of(context),
                                  const CustomSnackBar.error(
                                    message:
                                        'Có lỗi xảy ra. Vui lòng thử lại sau',
                                  ),
                                  displayDuration: const Duration(seconds: 0),
                                );
                              }
                            }
                          : null,
                      child: Text(
                        _buttonEnabled
                            ? 'Gửi lại mã OTP'
                            : 'Gửi lại mã sau (${_secondsRemaining}s)',
                        style: TextStyle(
                          fontSize: 16,
                          color: _buttonEnabled
                              ? buttonBackgroundColor
                              : Colors.grey,
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
