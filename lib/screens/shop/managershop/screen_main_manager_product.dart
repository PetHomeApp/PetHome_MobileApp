import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/screens/pet/screen_pet_homepage.dart';
import 'package:pethome_mobileapp/screens/shop/managershop/manager/screen_manager_pet.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class MainManagerProductScreen extends StatefulWidget {
  const MainManagerProductScreen({super.key, required this.initialIndex, required this.shopId});
  final int initialIndex;
  final String shopId;

  @override
  State<MainManagerProductScreen> createState() => _MainManagerProductScreenState();
}

class _MainManagerProductScreenState extends State<MainManagerProductScreen> {
  int _currentIndex = 0;
  // ignore: prefer_final_fields
  bool _isBottomBarVisible = true;

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
        ManagerPetScreen(updateBottomBarVisibility: updateBottomBarVisibility, shopId: widget.shopId),
        PetHomeScreen(updateBottomBarVisibility: updateBottomBarVisibility),
        PetHomeScreen(updateBottomBarVisibility: updateBottomBarVisibility),
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