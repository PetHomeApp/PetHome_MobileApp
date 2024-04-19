import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/screens/auth/screen_register.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  // ignore: library_private_types_in_public_api
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer _timer;
  int _secondsRemaining = 59;
  bool _buttonEnabled = true;

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

  @override
  void dispose() {
    _timer.cancel();
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
          "Bước 2: Xác nhận OTP",
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _textFieldOTP(first: true, last: false),
                          const SizedBox(width: 10),
                          _textFieldOTP(first: false, last: false),
                          const SizedBox(width: 10),
                          _textFieldOTP(first: false, last: false),
                          const SizedBox(width: 10),
                          _textFieldOTP(first: false, last: false),
                          const SizedBox(width: 10),
                          _textFieldOTP(first: false, last: false),
                          const SizedBox(width: 10),
                          _textFieldOTP(first: false, last: true),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    RegisterScreen(email: widget.email)),
                          );
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
                      height: 18,
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
                    const SizedBox(
                      height: 18,
                    ),
                    TextButton(
                      onPressed: _buttonEnabled
                          ? () {
                              _resetTimer();
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

  Widget _textFieldOTP({required bool first, required bool last}) {
    return SizedBox(
      height: 60,
      width: 50,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && !last) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && !first) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 2, color: buttonBackgroundColor),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
