import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/screens/screen_homepage.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/circle_widget.dart';
import 'package:pethome_mobileapp/widgets/shop/dash_widget.dart';

class CreateShopScreen4 extends StatefulWidget {
  const CreateShopScreen4({super.key});

  @override
  State<CreateShopScreen4> createState() => _CreateShopScreen4State();
}

class _CreateShopScreen4State extends State<CreateShopScreen4> {
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
                    const MainScreen(initialIndex: 4
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
          const Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Center(
                        child: Text(
                          "Tài khoản của bạn chưa được đăng kí cửa hàng. \n Hãy hoàn thành các bước để thực hiện đăng kí",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleWidget(color: buttonBackgroundColor),
                        DashWidget(color: buttonBackgroundColor),
                        CircleWidget(color: buttonBackgroundColor),
                        DashWidget(color: buttonBackgroundColor),
                        CircleWidget(color: buttonBackgroundColor),
                        DashWidget(color: buttonBackgroundColor),
                        CircleWidget(color: buttonBackgroundColor),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Center(
                        child: Text(
                          "Bước 4: Hoàn thành",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: buttonBackgroundColor),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: Column(
                        children: [
                          SizedBox(height: 45),
                          Text(
                            "Thông báo",
                            style: TextStyle(
                                color: buttonBackgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                          SizedBox(height: 20),
                          Text("Bạn đã hoàn thành đăng kí cửa hàng.",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                          Text(
                              "Chúng tôi sẽ kiểm duyệt tài khoản của bạn trong thời gian sớm nhất.",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                          Text("(Thời gian chậm nhất là 7 ngày)",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                          SizedBox(height: 15),
                          Text("PetHome xin chân thành cảm ơn!",
                              style: TextStyle(
                                  color: buttonBackgroundColor, fontSize: 18)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const MainScreen(initialIndex: 4
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
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: buttonBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Đi đến trang chủ của bạn',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
