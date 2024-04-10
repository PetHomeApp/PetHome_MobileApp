import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/pets/pet_card.dart';

class PetHomeScreen extends StatefulWidget {
  const PetHomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PetHomeScreenState createState() => _PetHomeScreenState();
}

class _PetHomeScreenState extends State<PetHomeScreen> {
  List<Pet> pets = [
    Pet(
        name: 'Mèo Hà Lan giống lùn',
        imageUrl: 'https://via.placeholder.com/150',
        shopName: "Cua hang 1",
        price: 50.0),
    Pet(
        name: 'Dog ABC',
        imageUrl: 'https://via.placeholder.com/150',
        shopName: "Cua hang 123 abc Le Xuan Huy",
        price: 100.0),
    Pet(
        name: 'Mèo Hà Lan ',
        imageUrl: 'https://via.placeholder.com/150',
        shopName: "Cua hang 1",
        price: 50.0),
    Pet(
        name: 'Dog',
        imageUrl: 'https://via.placeholder.com/150',
        shopName: "Cua hang 1",
        price: 100.0),
    Pet(
        name: 'Mèo Hà Lan giống lùn',
        imageUrl: 'https://via.placeholder.com/150',
        shopName: "Cua hang 1",
        price: 50.0),
    Pet(
        name: 'Dog',
        imageUrl: 'https://via.placeholder.com/150',
        shopName: "Cua hang 1",
        price: 100.0),
    Pet(
        name: 'Mèo Hà Lan giống lùn',
        imageUrl: 'https://via.placeholder.com/150',
        shopName: "Cua hang 1",
        price: 50.0),
    Pet(
        name: 'Dog',
        imageUrl: 'https://via.placeholder.com/150',
        shopName: "Cua hang 1",
        price: 100.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Nhập để tìm kiếm...',
                      border: InputBorder.none,
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                // Thực hiện hành động khi nút tìm kiếm được nhấn
              },
              icon: const Icon(
                Icons.search,
                size: 30,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [gradientAppBar, appColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          if (index % 2 == 0) {
            return Row(
              children: [
                Expanded(child: PetCard(pet: pets[index])),
                Expanded(child: PetCard(pet: pets[index + 1])),
              ],
            );
          }
          return Container(); // Trả về Container trống cho các chỉ số lẻ để tránh lỗi
        },
      ),
    );
  }
}
