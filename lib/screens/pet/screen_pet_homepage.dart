import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/pet/model_pet_in_card.dart';
import 'package:pethome_mobileapp/screens/pet/screen_pet_detail.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/pets/pet_card.dart';

class PetHomeScreen extends StatefulWidget {
  const PetHomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PetHomeScreenState createState() => _PetHomeScreenState();
}

class _PetHomeScreenState extends State<PetHomeScreen> {
  List<PetInCard> pets = [
    PetInCard(
        idPet: "id_pet",
        name: "name",
        imageUrl: "https://via.placeholder.com/150",
        shopName: "shopName",
        price: 0.0),
    PetInCard(
        idPet: "id_pet",
        name: "name",
        imageUrl: "https://via.placeholder.com/150",
        shopName: "shopName",
        price: 0.0),
    PetInCard(
        idPet: "id_pet",
        name: "name",
        imageUrl: "https://via.placeholder.com/150",
        shopName: "shopName",
        price: 0.0),
    PetInCard(
        idPet: "id_pet",
        name: "name",
        imageUrl: "https://via.placeholder.com/150",
        shopName: "shopName",
        price: 0.0),
    PetInCard(
        idPet: "id_pet",
        name: "name",
        imageUrl: "https://via.placeholder.com/150",
        shopName: "shopName",
        price: 0.0),
    PetInCard(
        idPet: "id_pet",
        name: "name",
        imageUrl: "https://via.placeholder.com/150",
        shopName: "shopName",
        price: 0.0),
    PetInCard(
        idPet: "id_pet",
        name: "name",
        imageUrl: "https://via.placeholder.com/150",
        shopName: "shopName",
        price: 0.0),
    PetInCard(
        idPet: "id_pet",
        name: "name",
        imageUrl: "https://via.placeholder.com/150",
        shopName: "shopName",
        price: 0.0),
    PetInCard(
        idPet: "id_pet",
        name: "name",
        imageUrl: "https://via.placeholder.com/150",
        shopName: "shopName",
        price: 0.0),
    PetInCard(
        idPet: "id_pet",
        name: "name",
        imageUrl: "https://via.placeholder.com/150",
        shopName: "shopName",
        price: 0.0),
    PetInCard(
        idPet: "id_pet",
        name: "name",
        imageUrl: "https://via.placeholder.com/150",
        shopName: "shopName",
        price: 0.0),
    PetInCard(
        idPet: "id_pet",
        name: "name",
        imageUrl: "https://via.placeholder.com/150",
        shopName: "shopName",
        price: 0.0),
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
              colors: [gradientAppBarColor, appColor],
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
                Expanded(
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PetDetailScreen(),
                          ));
                        },
                        child: PetCard(petInCard: pets[index]))),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PetDetailScreen(),
                          ));
                        },
                        child: PetCard(petInCard: pets[index + 1]))),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
