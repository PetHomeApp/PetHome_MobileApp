import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/services/api/user_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/enter_infor_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Color.fromARGB(232, 255, 255, 255),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Thay đổi mật khẩu",
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save, color: iconButtonColor, size: 30),
            onPressed: () async {
              if (_oldPasswordController.text.isEmpty ||
                  _newPasswordController.text.isEmpty ||
                  _confirmPasswordController.text.isEmpty) {
                showTopSnackBar(
                  // ignore: use_build_context_synchronously
                  Overlay.of(context),
                  const CustomSnackBar.error(
                    message: 'Vui lòng điền đầy đủ thông tin!',
                  ),
                  displayDuration: const Duration(seconds: 0),
                );
                return;
              } else if (_confirmPasswordController.text !=
                  _newPasswordController.text) {
                showTopSnackBar(
                  // ignore: use_build_context_synchronously
                  Overlay.of(context),
                  const CustomSnackBar.error(
                    message: 'Mật khẩu xác nhận không khớp!',
                  ),
                  displayDuration: const Duration(seconds: 0),
                );
                return;
              } else if (_newPasswordController.text ==
                  _oldPasswordController.text) {
                showTopSnackBar(
                  // ignore: use_build_context_synchronously
                  Overlay.of(context),
                  const CustomSnackBar.error(
                    message: 'Mật khẩu mới không được trùng với mật khẩu cũ!',
                  ),
                  displayDuration: const Duration(seconds: 0),
                );
                return;
              }

              var result = await UserApi().changePassword(
                  _oldPasswordController.text, _newPasswordController.text);

              if (result['isSuccess'] == true) {
                showTopSnackBar(
                  // ignore: use_build_context_synchronously
                  Overlay.of(context),
                  const CustomSnackBar.success(
                    message: 'Thay đổi mật khẩu thành công!',
                  ),
                  displayDuration: const Duration(seconds: 0),
                );
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              } else if (result['message'] == 'Mật khẩu cũ không đúng') {
                showTopSnackBar(
                  // ignore: use_build_context_synchronously
                  Overlay.of(context),
                  const CustomSnackBar.error(
                    message: 'Mật khẩu cũ không đúng!',
                  ),
                  displayDuration: const Duration(seconds: 0),
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
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
          child: Column(children: [
            InfoInputField(
              label: 'Mật khẩu cũ',
              controller: _oldPasswordController,
              hintText: 'Nhập mật khẩu cũ',
              obscureText: true,
            ),
            const SizedBox(height: 20),
            InfoInputField(
              label: 'Mật khẩu mới',
              controller: _newPasswordController,
              hintText: 'Nhập mật khẩu mới',
              obscureText: true,
            ),
            const SizedBox(height: 20),
            InfoInputField(
              label: 'Xác nhận mật khẩu',
              controller: _confirmPasswordController,
              hintText: 'Nhập lại mật khẩu mới',
              obscureText: true,
            ),
          ]),
        ),
      ),
    );
  }
}
