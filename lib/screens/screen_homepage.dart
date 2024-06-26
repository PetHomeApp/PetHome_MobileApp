import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/screens/blog/screen_blog_homepage.dart';
import 'package:pethome_mobileapp/screens/product/item/screen_item_homepage.dart';
import 'package:pethome_mobileapp/screens/my/screen_my_homepage.dart';
import 'package:pethome_mobileapp/screens/product/pet/screen_pet_homepage.dart';
import 'package:pethome_mobileapp/screens/product/service/screen_service_homepage.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.initialIndex});
  final int initialIndex;

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isBottomBarVisible = true;
  // ignore: prefr_final_fields

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void updateBottomBarVisibility(bool isVisible) {
    setState(() {
      _isBottomBarVisible = isVisible;
    });
  }  

  List<Widget> get _pages => [
        PetHomeScreen(updateBottomBarVisibility: updateBottomBarVisibility),
        ItemHomeScreen(updateBottomBarVisibility: updateBottomBarVisibility),
        const ServiceHomeScreen(),
        BlogHomeScreen(updateBottomBarVisibility: updateBottomBarVisibility),
        const MyHomePageScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _isBottomBarVisible ? kBottomNavigationBarHeight : 0,
        child: SingleChildScrollView(
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _currentIndex == 0 ?
                const Icon(Icons.cruelty_free) : const Icon(Icons.cruelty_free_outlined),
                label: 'Thú cưng',
              ),
              BottomNavigationBarItem(
                icon: _currentIndex == 1 ?
                const Icon(Icons.shopping_bag) : const Icon(Icons.shopping_bag_outlined),
                label: 'Vật phẩm',
              ),
              BottomNavigationBarItem(
                icon: _currentIndex == 2 ?
                const Icon(Icons.medication_liquid) : const Icon(Icons.medication_liquid_sharp),
                label: 'Dịch vụ',
              ),
              BottomNavigationBarItem(
                icon: _currentIndex == 3 ?
                const Icon(Icons.article) : const Icon(Icons.article_outlined),
                label: 'Blog',
              ),
              BottomNavigationBarItem(
                icon: _currentIndex == 4 ?
                const Icon(Icons.person) : const Icon(Icons.person_outlined),
                label: 'Tôi',
              ),
            ],
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: buttonBackgroundColor,
            onTap: (index) async {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
