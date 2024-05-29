import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_register.dart';
import 'package:pethome_mobileapp/screens/screen_homepage.dart';
import 'package:pethome_mobileapp/screens/shop/createShop/screen_create_shop_2.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/setting/list_area.dart';
import 'package:pethome_mobileapp/widgets/shop/circle_widget.dart';
import 'package:pethome_mobileapp/widgets/shop/dash_widget.dart';
import 'package:pethome_mobileapp/widgets/shop/enter_infor_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CreateShopScreen1 extends StatefulWidget {
  const CreateShopScreen1({super.key, required this.shopInforRegister});
  final ShopInforRegister shopInforRegister;

  @override
  State<CreateShopScreen1> createState() => _CreateShopScreen1State();
}

class _CreateShopScreen1State extends State<CreateShopScreen1> {
  late ShopInforRegister lateShopInforRegister;

  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopAddressController = TextEditingController();
  String? selectedArea = area[0];

  XFile? logo;

  @override
  void initState() {
    super.initState();
    shopNameController.text = widget.shopInforRegister.shopName;
    shopAddressController.text = widget.shopInforRegister.shopAddress;
    selectedArea = widget.shopInforRegister.area == ''
        ? area[0]
        : widget.shopInforRegister.area;
    logo = widget.shopInforRegister.logo;
  }

  // ignore: unused_element
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await showDialog<XFile>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn hình ảnh'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(
                  // ignore: use_build_context_synchronously
                  context,
                  await picker.pickImage(source: ImageSource.camera));
            },
            child: const Text('Chụp hình',
                style: TextStyle(color: buttonBackgroundColor)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(
                  // ignore: use_build_context_synchronously
                  context,
                  await picker.pickImage(source: ImageSource.gallery));
            },
            child: const Text('Chọn từ album',
                style: TextStyle(color: buttonBackgroundColor)),
          ),
        ],
      ),
    );

    if (pickedImage != null) {
      setState(() {
        logo = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    shopNameController.dispose();
    shopAddressController.dispose();
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
            size: 20,
            color: Color.fromARGB(232, 255, 255, 255),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const MainScreen(initialIndex: 4),
                transitionsBuilder: (context, animation1, animation2, child) {
                  const begin = Offset(-1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  final tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  final offsetAnimation = animation1.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 200),
              ),
              (route) => false,
            );
          },
        ),
        title: const Text(
          "Đăng kí cửa hàng",
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
      body: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Center(
                        child: Text(
                          "Tài khoản của bạn chưa được đăng kí cửa hàng. \n Hãy hoàn thành các bước để thực hiện đăng kí",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleWidget(color: buttonBackgroundColor),
                        DashWidget(color: Color.fromARGB(91, 158, 158, 158)),
                        CircleWidget(color: Color.fromARGB(91, 158, 158, 158)),
                        DashWidget(color: Color.fromARGB(91, 158, 158, 158)),
                        CircleWidget(color: Color.fromARGB(91, 158, 158, 158)),
                        DashWidget(color: Color.fromARGB(91, 158, 158, 158)),
                        CircleWidget(color: Color.fromARGB(91, 158, 158, 158)),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Center(
                        child: Text(
                          "Bước 1: Thông tin cửa hàng",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: buttonBackgroundColor),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Column(
                        children: [
                          InfoInputField(
                            controller: shopNameController,
                            label: 'Tên cửa hàng: (*)',
                            hintText: '',
                          ),
                          const SizedBox(height: 20.0),
                          InfoInputField(
                            controller: shopAddressController,
                            label: 'Địa chỉ cửa hàng: (*)',
                            hintText: '',
                          ),
                          const SizedBox(height: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Khu vực: (*)',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4.0),
                              DropdownButtonFormField(
                                value: selectedArea,
                                items: area.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedArea = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                      color: buttonBackgroundColor,
                                      width: 2.0,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 12.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          InfoInputField(
                            label: 'Email: (*)',
                            hintText: widget.shopInforRegister.email,
                            enabled: false,
                            controller: TextEditingController(),
                          ),
                          const SizedBox(height: 20.0),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Chọn ảnh đại diện cho cửa hàng: (*)',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: 120.0,
                                height: 120.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: gradientMidColor,
                                ),
                                child: logo?.path != ''
                                    ? ClipOval(
                                        child: Image.file(
                                          File(logo!.path),
                                          width: 120.0,
                                          height: 120.0,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.image,
                                        size: 60.0,
                                        color: Colors.white,
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
          ),
          Positioned(
            right: 30,
            bottom: 40,
            child: InkWell(
              onTap: () async {
                if (shopAddressController.text.isEmpty ||
                    shopNameController.text.isEmpty ||
                    logo?.path == '') {
                  showTopSnackBar(
                    // ignore: use_build_context_synchronously
                    Overlay.of(context),
                    const CustomSnackBar.error(
                      message: 'Vui lòng điền đầy đủ thông tin cửa hàng',
                    ),
                    displayDuration: const Duration(seconds: 0),
                  );
                  return;
                } else {
                  lateShopInforRegister = ShopInforRegister(
                    email: widget.shopInforRegister.email,
                    shopName: shopNameController.text,
                    shopAddress: shopAddressController.text,
                    area: selectedArea!,
                    logo: logo!,
                    taxCode: widget.shopInforRegister.taxCode,
                    businessType: widget.shopInforRegister.businessType,
                    ownerName: widget.shopInforRegister.ownerName,
                    idCard: widget.shopInforRegister.idCard,
                    idCardFront: widget.shopInforRegister.idCardFront,
                    idCardBack: widget.shopInforRegister.idCardBack,
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateShopScreen2(
                            shopInforRegister: lateShopInforRegister)),
                    (route) => false,
                  );
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: buttonBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Tiếp tục',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
