import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/pet/model_pet_in_card.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/cart/pet_cart_widget.dart';

class CartHomePageScreen extends StatefulWidget {
  const CartHomePageScreen({super.key});

  @override
  State<CartHomePageScreen> createState() => _CartHomePageScreenState();
}

class _CartHomePageScreenState extends State<CartHomePageScreen> {
  bool loading = false;

  List<PetInCard> pets = [
    PetInCard(
      idPet: '1',
      name: 'Cún cưng cực kỳ dễ thương - siêu cute',
      imageUrl: 'https://via.placeholder.com/150',
      shopName: 'Shop 1',
      price: 1000000,
      ageID: 1,
      specieID: 1,
      areas: ['Hà Nội'],
      inStock: true,
    ),
    PetInCard(
      idPet: '2',
      name: 'Mèo cưng',
      imageUrl: 'https://via.placeholder.com/150',
      shopName: 'Shop 2',
      price: 2000000,
      ageID: 2,
      specieID: 2,
      areas: ['Hà Nội'],
      inStock: false,
    ),
    PetInCard(
      idPet: '3',
      name: 'Chó cưng',
      imageUrl: 'https://via.placeholder.com/150',
      shopName: 'Shop 3',
      price: 3000000,
      ageID: 3,
      specieID: 3,
      areas: ['Hà Nội'],
      inStock: true,
    ),
  ];

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
        : DefaultTabController(
            length: 2,
            child: Scaffold(
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
                  "Giỏ hàng",
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
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Container(
                    color: Colors.white,
                    child: const TabBar(
                      indicatorColor: buttonBackgroundColor,
                      labelColor: buttonBackgroundColor,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(text: 'Thú cưng'),
                        Tab(text: 'Vật phẩm'),
                      ],
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ListView.builder(
                      itemCount: pets.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return PetCartWidget(
                          petInCard: pets[index],
                          onRemove: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Xác nhận"),
                                  content: const Text(
                                      "Bạn có chắc chắn muốn xóa thú cưng khỏi giỏ hàng không?"),
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
                                        setState(() {
                                          pets.removeAt(index);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Xóa",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 209, 87, 78))),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Center(child: Text('Vat pham')),
                ],
              ),
            ),
          );
  }
}
