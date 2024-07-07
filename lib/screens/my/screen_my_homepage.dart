import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_register.dart';
import 'package:pethome_mobileapp/model/user/model_user_infor.dart';
import 'package:pethome_mobileapp/screens/auth/screen_login.dart';
import 'package:pethome_mobileapp/screens/cart/screen_cart_homepage.dart';
import 'package:pethome_mobileapp/screens/chat/screen_chat_homepage.dart';
import 'package:pethome_mobileapp/screens/my/address/screen_list_address.dart';
import 'package:pethome_mobileapp/screens/my/screen_change_password.dart';
import 'package:pethome_mobileapp/screens/my/screen_favorite_pets.dart';
import 'package:pethome_mobileapp/screens/my/screen_notification.dart';
import 'package:pethome_mobileapp/screens/my/screen_update_infor_user.dart';
import 'package:pethome_mobileapp/screens/my/bill/screen_user_bill.dart';
import 'package:pethome_mobileapp/screens/shop/createShop/screen_create_shop_1.dart';
import 'package:pethome_mobileapp/screens/shop/createShop/screen_create_shop_4.dart';
import 'package:pethome_mobileapp/screens/shop/managershop/screen_manager_shop.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/services/api/user_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MyHomePageScreen extends StatefulWidget {
  const MyHomePageScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageScreenState createState() => _MyHomePageScreenState();
}

class _MyHomePageScreenState extends State<MyHomePageScreen> {
  bool loading = false;
  late UserInfor userInfor;
  late bool isShop = false;
  late bool isActiveShop = false;
  late String idShop;

  late SharedPreferences sharedPreferences;
  late ShopInforRegister shopInforRegister;

  XFile? avatarFile;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    getUserInfor();
  }

  _initPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  _resetPrefs() async {
    await sharedPreferences.clear();
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
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> checkAccountIsShop() async {
    if (loading) {
      return;
    }

    loading = true;
    ShopApi shopApi = ShopApi();
    final dataResponse = await shopApi.checkIsRegisterShop();

    if (dataResponse['isSuccess'] == true) {
      setState(() {
        isShop = true;
        loading = false;
      });
    } else {
      setState(() {
        isShop = false;
        loading = false;
      });
    }
  }

  Future<void> checkIsActiveShop() async {
    if (loading) {
      return;
    }

    loading = true;
    ShopApi shopApi = ShopApi();
    final dataResponse = await shopApi.checkIsActiveShop();

    if (dataResponse['isSuccess'] == true) {
      setState(() {
        isActiveShop = true;
        idShop = dataResponse['shopId'];
        loading = false;
      });
    } else {
      setState(() {
        isActiveShop = false;
        idShop = '';
        loading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await showDialog<XFile>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thay đổi ảnh đại diện'),
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
      var res = await UserApi().updateAvatar(pickedImage);
      if (res['isSuccess'] == true) {
        setState(() {
          getUserInfor();
        });
        showTopSnackBar(
          // ignore: use_build_context_synchronously
          Overlay.of(context),
          const CustomSnackBar.success(
            message: 'Cập nhật ảnh đại diện thành công',
          ),
          displayDuration: const Duration(seconds: 0),
        );
      } else {
        showTopSnackBar(
          // ignore: use_build_context_synchronously
          Overlay.of(context),
          const CustomSnackBar.error(
            message: 'Cập nhật ảnh đại diện thất bại',
          ),
          displayDuration: const Duration(seconds: 0),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Menu",
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
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: appColor,
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    _pickImage();
                                  },
                                  child: SizedBox(
                                    width: 100.0,
                                    height: 100.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3.0,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                        child: Image.network(
                                          userInfor.avatar,
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Image.asset(
                                                'lib/assets/pictures/placeholder_image.png',
                                                fit: BoxFit.cover);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        userInfor.name,
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        softWrap: true,
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 30),
                                        child: Text(
                                          'ID: ${userInfor.idUser.substring(0, 8)}...',
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.notifications,
                                    color: buttonBackgroundColor,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationScreen(),
                                    ));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[100],
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(15),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const ChatHomeScreen(),
                                        ));
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: SizedBox(
                                              width: 35,
                                              height: 35,
                                              child: Image.asset(
                                                  'lib/assets/pictures/icon_chat.png'),
                                            ),
                                          ),
                                          const Text(
                                            'Tin nhắn',
                                            style: TextStyle(
                                              color: buttonBackgroundColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[100],
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(15),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const CartHomePageScreen(),
                                        ));
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: SizedBox(
                                              width: 35,
                                              height: 35,
                                              child: Image.asset(
                                                  'lib/assets/pictures/icon_cart.png'),
                                            ),
                                          ),
                                          const Text(
                                            'Giỏ hàng',
                                            style: TextStyle(
                                              color: buttonBackgroundColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[100],
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(15),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const UserBillScreen(),
                                        ));
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: SizedBox(
                                              width: 35,
                                              height: 35,
                                              child: Image.asset(
                                                  'lib/assets/pictures/icon_order.png'),
                                            ),
                                          ),
                                          const Text(
                                            'Đơn hàng của tôi',
                                            style: TextStyle(
                                              color: buttonBackgroundColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[100],
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(15),
                                    child: InkWell(
                                      onTap: () async {
                                        await checkAccountIsShop();
                                        await checkIsActiveShop();
                                        if (isShop) {
                                          if (isActiveShop) {
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ShopManagementScreen(
                                                      idShop: idShop),
                                            ));
                                          } else {
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const CreateShopScreen4(),
                                            ));
                                          }
                                        } else {
                                          shopInforRegister = ShopInforRegister(
                                            email: userInfor.email,
                                            shopName: '',
                                            shopAddress: '',
                                            area: '',
                                            logo: XFile(''),
                                            taxCode: '',
                                            businessType: '',
                                            ownerName: '',
                                            idCard: '',
                                            idCardFront: XFile(''),
                                            idCardBack: XFile(''),
                                          );
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                CreateShopScreen1(
                                                    shopInforRegister:
                                                        shopInforRegister),
                                          ));
                                        }
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: SizedBox(
                                              width: 35,
                                              height: 35,
                                              child: Image.asset(
                                                  'lib/assets/pictures/icon_shop.png'),
                                            ),
                                          ),
                                          const Text(
                                            'Quản lý cửa hàng',
                                            style: TextStyle(
                                              color: buttonBackgroundColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const FavoritePetsScreen(),
                          ));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color.fromARGB(140, 158, 158, 158),
                                width: 0.5,
                              ),
                              bottom: BorderSide(
                                color: Color.fromARGB(140, 158, 158, 158),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: buttonBackgroundColor,
                                  size: 30,
                                ),
                                SizedBox(width: 15),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Thú cưng yêu thích',
                                    style: TextStyle(
                                      color: buttonBackgroundColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                builder: (context) =>
                                    const UpdateInforUserScreen(),
                              ))
                              .then((value) => getUserInfor());
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color.fromARGB(140, 158, 158, 158),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: buttonBackgroundColor,
                                  size: 30,
                                ),
                                SizedBox(width: 15),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Thông tin cá nhân',
                                    style: TextStyle(
                                      color: buttonBackgroundColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ListAddressScreen(),
                          ));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color.fromARGB(140, 158, 158, 158),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: buttonBackgroundColor,
                                  size: 30,
                                ),
                                SizedBox(width: 15),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Quản lý địa chỉ',
                                    style: TextStyle(
                                      color: buttonBackgroundColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color.fromARGB(140, 158, 158, 158),
                                width: 0.5,
                              ),
                              bottom: BorderSide(
                                color: Color.fromARGB(140, 158, 158, 158),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lock,
                                  color: buttonBackgroundColor,
                                  size: 30,
                                ),
                                SizedBox(width: 15),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Đổi mật khẩu',
                                    style: TextStyle(
                                      color: buttonBackgroundColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: buttonBackgroundColor,
                      ),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Xác nhận"),
                                content: const Text(
                                    "Bạn có chắc chắn muốn đăng xuất không?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Không",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 84, 84, 84))),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _resetPrefs();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()),
                                        (route) => false,
                                      );
                                    },
                                    child: const Text("Đăng xuất",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 209, 87, 78))),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Center(
                          child: Text(
                            'Đăng xuất',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
