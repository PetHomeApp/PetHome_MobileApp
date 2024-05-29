import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_register.dart';
import 'package:pethome_mobileapp/screens/shop/createShop/screen_create_shop_2.dart';
import 'package:pethome_mobileapp/screens/shop/createShop/screen_create_shop_4.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/circle_widget.dart';
import 'package:pethome_mobileapp/widgets/shop/dash_widget.dart';
import 'package:pethome_mobileapp/widgets/shop/enter_infor_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CreateShopScreen3 extends StatefulWidget {
  const CreateShopScreen3({super.key, required this.shopInforRegister});
  final ShopInforRegister shopInforRegister;

  @override
  State<CreateShopScreen3> createState() => _CreateShopScreen3State();
}

class _CreateShopScreen3State extends State<CreateShopScreen3> {
  late ShopInforRegister lateShopInforRegister;

  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();

  // ignore: non_constant_identifier_names
  XFile? _image_front;
  // ignore: non_constant_identifier_names
  XFile? _image_back;

  @override
  void initState() {
    super.initState();
    _ownerNameController.text = widget.shopInforRegister.ownerName;
    _idCardController.text = widget.shopInforRegister.idCard;
    _image_front = widget.shopInforRegister.idCardFront;
    _image_back = widget.shopInforRegister.idCardBack;
  }

  Future<void> _pickImageFront() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final ImagePicker _picker = ImagePicker();
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
                  await _picker.pickImage(source: ImageSource.camera));
            },
            child: const Text('Chụp hình',
                style: TextStyle(color: buttonBackgroundColor)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(
                  // ignore: use_build_context_synchronously
                  context,
                  await _picker.pickImage(source: ImageSource.gallery));
            },
            child: const Text('Chọn từ album',
                style: TextStyle(color: buttonBackgroundColor)),
          ),
        ],
      ),
    );

    if (pickedImage != null) {
      setState(() {
        _image_front = pickedImage;
      });
    }
  }

  Future<void> _pickImage() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final ImagePicker _picker = ImagePicker();
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
                  await _picker.pickImage(source: ImageSource.camera));
            },
            child: const Text('Chụp hình',
                style: TextStyle(color: buttonBackgroundColor)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(
                  // ignore: use_build_context_synchronously
                  context,
                  await _picker.pickImage(source: ImageSource.gallery));
            },
            child: const Text('Chọn từ album',
                style: TextStyle(color: buttonBackgroundColor)),
          ),
        ],
      ),
    );

    if (pickedImage != null) {
      setState(() {
        _image_back = pickedImage;
      });
    }
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
            lateShopInforRegister = ShopInforRegister(
              email: widget.shopInforRegister.email,
              shopName: widget.shopInforRegister.shopName,
              shopAddress: widget.shopInforRegister.shopAddress,
              area: widget.shopInforRegister.area,
              logo: widget.shopInforRegister.logo,
              taxCode: widget.shopInforRegister.taxCode,
              businessType: widget.shopInforRegister.businessType,
              ownerName: _ownerNameController.text,
              idCard: _idCardController.text,
              idCardFront: _image_front!,
              idCardBack: _image_back!,
            );
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    CreateShopScreen2(
                  shopInforRegister: lateShopInforRegister,
                ),
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
                        DashWidget(color: buttonBackgroundColor),
                        CircleWidget(color: buttonBackgroundColor),
                        DashWidget(color: buttonBackgroundColor),
                        CircleWidget(color: buttonBackgroundColor),
                        DashWidget(color: Color.fromARGB(91, 158, 158, 158)),
                        CircleWidget(color: Color.fromARGB(91, 158, 158, 158)),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Center(
                        child: Text(
                          "Bước 3: Thông tin xác thực",
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
                            label: 'Họ và tên : (*)',
                            hintText: '',
                            controller: _ownerNameController,
                          ),
                          const SizedBox(height: 20.0),
                          InfoInputField(
                            label: 'Mã số CCCD: (*)',
                            hintText: '',
                            keyboardType: TextInputType.number,
                            controller: _idCardController,
                          ),
                          const SizedBox(height: 20.0),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Ảnh mặt trước CCCD (kèm mặt): (*)',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          GestureDetector(
                            onTap: _pickImageFront,
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: _image_front!.path == ''
                                  ? const Center(
                                      child: Text(
                                        '+',
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.file(
                                        File(_image_front!.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Ảnh mặt sau CCCD: (*)',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: _image_back?.path == ''
                                  ? const Center(
                                      child: Text(
                                        '+',
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.file(
                                        File(_image_back!.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () async {
                                if (_ownerNameController.text.isEmpty ||
                                    _idCardController.text.isEmpty ||
                                    _image_front?.path == '' ||
                                    _image_back?.path == '') {
                                  showTopSnackBar(
                                    // ignore: use_build_context_synchronously
                                    Overlay.of(context),
                                    const CustomSnackBar.error(
                                      message:
                                          'Vui lòng điền đầy đủ thông tin cửa hàng',
                                    ),
                                    displayDuration: const Duration(seconds: 0),
                                  );
                                  return;
                                }
                                lateShopInforRegister = ShopInforRegister(
                                  email: widget.shopInforRegister.email,
                                  shopName: widget.shopInforRegister.shopName,
                                  shopAddress:
                                      widget.shopInforRegister.shopAddress,
                                  area: widget.shopInforRegister.area,
                                  logo: widget.shopInforRegister.logo,
                                  taxCode: widget.shopInforRegister.taxCode,
                                  businessType:
                                      widget.shopInforRegister.businessType,
                                  ownerName: _ownerNameController.text,
                                  idCard: _idCardController.text,
                                  idCardFront: _image_front!,
                                  idCardBack: _image_back!,
                                );

                                var result = await ShopApi()
                                    .registerShop(lateShopInforRegister);

                                if (result['isSuccess'] == false) {
                                  showTopSnackBar(
                                    // ignore: use_build_context_synchronously
                                    Overlay.of(context),
                                    const CustomSnackBar.error(
                                      message:
                                          'Đăng kí cửa hàng không thành công',
                                    ),
                                    displayDuration: const Duration(seconds: 0),
                                  );
                                  return;
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateShopScreen4(),
                                  ));
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
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
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
