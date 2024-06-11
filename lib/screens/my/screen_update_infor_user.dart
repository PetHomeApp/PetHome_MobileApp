import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/user/model_user_infor.dart';
import 'package:pethome_mobileapp/services/api/user_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/enter_infor_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UpdateInforUserScreen extends StatefulWidget {
  const UpdateInforUserScreen({super.key});

  @override
  State<UpdateInforUserScreen> createState() => _UpdateInforUserScreenState();
}

class _UpdateInforUserScreenState extends State<UpdateInforUserScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userNumberPhoneController =
      TextEditingController();
  final TextEditingController _userDoBController = TextEditingController();

  DateTime? _selectedDate;
  bool loading = false;

  late UserInfor userInfor;
  String selectedGender = '';

  @override
  void initState() {
    super.initState();
    getUserInfor();
  }

  Future<void> getUserInfor() async {
    if (loading) {
      return;
    }

    loading = true;
    final dataResponse = await UserApi().getUser();

    if (dataResponse['isSuccess'] == true) {
      setState(() {
        loading = false;
        userInfor = dataResponse['userInfor'];

        _userNameController.text = userInfor.name;
        _userEmailController.text = userInfor.email;
        if (userInfor.gender == 'male' || userInfor.gender == '') {
          selectedGender = 'Nam';
        } else if (userInfor.gender == 'female') {
          selectedGender = 'Nữ';
        } else {
          selectedGender = 'Khác';
        }
        _userNumberPhoneController.text = userInfor.phoneNum;
        String getDayString = '';
        if (userInfor.dayOfBirth == '') {
          getDayString = '';
        } else {
          getDayString = userInfor.dayOfBirth.substring(0, 10);
        }
        _userDoBController.text = getDayString;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _userDoBController.text =
            "${picked.year.toString()}-${picked.month.toString().padLeft(2, "0")}-${picked.day.toString().padLeft(2, "0")}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: buttonBackgroundColor,
              ),
            ),
          )
        : Scaffold(
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
                "Thông tin cá nhân",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      gradientStartColor,
                      gradientMidColor,
                      gradientEndColor
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon:
                      const Icon(Icons.save, color: iconButtonColor, size: 30),
                  onPressed: () async {
                    if (_userNameController.text == '') {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message: 'Bạn phải nhập tên người dùng!',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                      return;
                    }

                    String genderSend = '';
                    if (selectedGender == 'Nam') {
                      genderSend = 'male';
                    } else if (selectedGender == 'Nữ') {
                      genderSend = 'female';
                    } else {
                      genderSend = 'other';
                    }

                    var response = await UserApi().updateInfor(
                      _userNameController.text,
                      _userNumberPhoneController.text,
                      genderSend,
                      _userDoBController.text
                    );

                    if (response['isSuccess'] == true) {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.success(
                          message: 'Cập nhật thông tin thành công!',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                    } else {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message: 'Cập nhật thông tin thất bại!',
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
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
                child: Column(children: [
                  InfoInputField(
                    label: 'Tên người dùng: (*)',
                    hintText: '',
                    controller: _userNameController,
                  ),
                  const SizedBox(height: 20.0),
                  InfoInputField(
                    label: 'Email: (*)',
                    hintText: '',
                    controller: _userEmailController,
                    enabled: false,
                  ),
                  const SizedBox(height: 20.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Giới tính:',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    onChanged: (newValue) {
                      setState(() {
                        selectedGender = newValue!;
                      });
                    },
                    items: <String>["Nam", "Nữ", "Khác"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 0.75,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 0.75,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: buttonBackgroundColor,
                          width: 1.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  InfoInputField(
                    label: 'Số điện thoại: (*)',
                    hintText: '',
                    controller: _userNumberPhoneController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ngày sinh:',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  TextField(
                    controller: _userDoBController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 0.75,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 0.75,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: buttonBackgroundColor,
                          width: 1.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                ]),
              ),
            ),
          );
  }
}
