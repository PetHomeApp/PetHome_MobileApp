import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_register.dart';
import 'package:pethome_mobileapp/screens/shop/createShop/screen_create_shop_1.dart';
import 'package:pethome_mobileapp/screens/shop/createShop/screen_create_shop_3.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/circle_widget.dart';
import 'package:pethome_mobileapp/widgets/shop/dash_widget.dart';
import 'package:pethome_mobileapp/widgets/shop/enter_infor_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CreateShopScreen2 extends StatefulWidget {
  const CreateShopScreen2({super.key, required this.shopInforRegister});
  final ShopInforRegister shopInforRegister;

  @override
  State<CreateShopScreen2> createState() => _CreateShopScreen2State();
}

enum UserType { individual, household, business }

class _CreateShopScreen2State extends State<CreateShopScreen2> {
  late ShopInforRegister lateShopInforRegister;
  late String businessType;

  UserType _selectedUserType = UserType.individual;
  TextEditingController taxCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    taxCodeController.text = widget.shopInforRegister.taxCode;
    businessType = widget.shopInforRegister.businessType;
    if (businessType == '' || businessType == 'Cá nhân') {
      _selectedUserType = UserType.individual;
    } else if (businessType == 'Hộ gia đình') {
      _selectedUserType = UserType.household;
    } else {
      _selectedUserType = UserType.business;
    }
  }

  @override
  void dispose() {
    taxCodeController.dispose();
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
            lateShopInforRegister = ShopInforRegister(
              email: widget.shopInforRegister.email,
              shopName: widget.shopInforRegister.shopName,
              shopAddress: widget.shopInforRegister.shopAddress,
              area: widget.shopInforRegister.area,
              logo: widget.shopInforRegister.logo,
              taxCode: taxCodeController.text,
              businessType: _selectedUserType == UserType.individual
                  ? 'Cá nhân'
                  : _selectedUserType == UserType.household
                      ? 'Hộ gia đình'
                      : 'Doanh nghiệp',
              ownerName: widget.shopInforRegister.ownerName,
              idCard: widget.shopInforRegister.idCard,
              idCardFront: widget.shopInforRegister.idCardFront,
              idCardBack: widget.shopInforRegister.idCardBack,
            );
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    CreateShopScreen1(
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
                          "Bước 2: Thông tin thuế",
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
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Loại hình kinh doanh: (*)',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio<UserType>(
                                    value: UserType.individual,
                                    activeColor: buttonBackgroundColor,
                                    groupValue: _selectedUserType,
                                    onChanged: (UserType? value) {
                                      setState(() {
                                        _selectedUserType = value!;
                                      });
                                    },
                                  ),
                                  const Text('Cá nhân'),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Radio<UserType>(
                                    value: UserType.household,
                                    activeColor: buttonBackgroundColor,
                                    groupValue: _selectedUserType,
                                    onChanged: (UserType? value) {
                                      setState(() {
                                        _selectedUserType = value!;
                                      });
                                    },
                                  ),
                                  const Text('Hộ gia đình'),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Radio<UserType>(
                                    value: UserType.business,
                                    activeColor: buttonBackgroundColor,
                                    groupValue: _selectedUserType,
                                    onChanged: (UserType? value) {
                                      setState(() {
                                        _selectedUserType = value!;
                                      });
                                    },
                                  ),
                                  const Text('Doanh nghiệp'),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          InfoInputField(
                            label: 'Mã số thuế: (*)',
                            hintText: '',
                            keyboardType: TextInputType.number,
                            controller: taxCodeController,
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
              onTap: () {
                if (taxCodeController.text.isEmpty) {
                  showTopSnackBar(
                    // ignore: use_build_context_synchronously
                    Overlay.of(context),
                    const CustomSnackBar.error(
                      message: 'Vui lòng điền đầy đủ thông tin cửa hàng',
                    ),
                    displayDuration: const Duration(seconds: 0),
                  );
                  return;
                }
                lateShopInforRegister = ShopInforRegister(
                  email: widget.shopInforRegister.email,
                  shopName: widget.shopInforRegister.shopName,
                  shopAddress: widget.shopInforRegister.shopAddress,
                  area: widget.shopInforRegister.area,
                  logo: widget.shopInforRegister.logo,
                  taxCode: taxCodeController.text,
                  businessType: _selectedUserType == UserType.individual
                      ? 'Cá nhân'
                      : _selectedUserType == UserType.household
                          ? 'Hộ gia đình'
                          : 'Doanh nghiệp',
                  ownerName: widget.shopInforRegister.ownerName,
                  idCard: widget.shopInforRegister.idCard,
                  idCardFront: widget.shopInforRegister.idCardFront,
                  idCardBack: widget.shopInforRegister.idCardBack,
                );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateShopScreen3(
                          shopInforRegister: lateShopInforRegister)),
                  (route) => false,
                );
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
