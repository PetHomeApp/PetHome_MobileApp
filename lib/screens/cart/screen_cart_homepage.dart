import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/item/model_item_cart.dart';
import 'package:pethome_mobileapp/model/pet/model_pet_in_card.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/cart/item_cart_widget.dart';
import 'package:pethome_mobileapp/widgets/cart/pet_cart_widget.dart';

class CartHomePageScreen extends StatefulWidget {
  const CartHomePageScreen({super.key});

  @override
  State<CartHomePageScreen> createState() => _CartHomePageScreenState();
}

class _CartHomePageScreenState extends State<CartHomePageScreen> {
  bool loading = false;
  bool isCheckAllItem = false;
  int total = 0;

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

  List<ItemCart> items = [
    ItemCart(
      idItem: '1',
      idItemDetail: '1',
      name: 'Thức ăn cho chó',
      unit: 'gói',
      shopId: '1',
      shopName: 'Shop 1',
      price: 100000,
      picture: 'https://via.placeholder.com/150',
      size: '1kg',
      inStock: true,
    ),
    ItemCart(
      idItem: '2',
      idItemDetail: '2',
      name: 'Thức ăn cho mèo',
      unit: 'gói',
      shopId: '2',
      shopName: 'Shop 2',
      price: 200000,
      picture: 'https://via.placeholder.com/150',
      size: '1kg',
      inStock: false,
    ),
    ItemCart(
      idItem: '3',
      idItemDetail: '3',
      name: 'Thức ăn cho thỏ',
      unit: 'gói',
      shopId: '3',
      shopName: 'Shop 3',
      price: 300000,
      picture: 'https://via.placeholder.com/150',
      size: '1kg',
      inStock: true,
    ),
    ItemCart(
      idItem: '1',
      idItemDetail: '1',
      name: 'Thức ăn cho chó',
      unit: 'gói',
      shopId: '1',
      shopName: 'Shop 1',
      price: 100000,
      picture: 'https://via.placeholder.com/150',
      size: '1kg',
      inStock: true,
    ),
    ItemCart(
      idItem: '2',
      idItemDetail: '2',
      name: 'Thức ăn cho mèo',
      unit: 'gói',
      shopId: '2',
      shopName: 'Shop 2',
      price: 200000,
      picture: 'https://via.placeholder.com/150',
      size: '1kg',
      inStock: false,
    ),
    ItemCart(
      idItem: '3',
      idItemDetail: '3',
      name: 'Thức ăn cho thỏ',
      unit: 'gói',
      shopId: '3',
      shopName: 'Shop 3',
      price: 300000,
      picture: 'https://via.placeholder.com/150',
      size: '1kg',
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
                  Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: ListView.builder(
                            itemCount: items.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 16),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return _buildItemCartWidget(
                                          context, items[index], index);
                                    },
                                  ),
                                  const SizedBox(height: 10)
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      // Footer
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isCheckAllItem,
                                      checkColor: Colors.white,
                                      onChanged: (value) {
                                        setState(() {
                                          isCheckAllItem = value!;
                                          if (isCheckAllItem) {
                                            for (var element in items) {
                                              element.isCheckBox = true;
                                            }
                                          } else {
                                            for (var element in items) {
                                              element.isCheckBox = false;
                                            }
                                          }
                                          total = calculateTotal(items);
                                        });
                                      },
                                      activeColor: buttonBackgroundColor,
                                    ),
                                    const Text(
                                      'Tất cả',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 84, 84, 84),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Tổng cộng:',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 84, 84, 84),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${NumberFormat('#,##0', 'vi').format(total)} đ',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: buttonBackgroundColor,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    GestureDetector(
                                      onTap: () {
                                        // Điều hướng đến màn hình thanh toán
                                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CheckoutScreen()));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: buttonBackgroundColor,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: const Center(
                                          child: Text(
                                            'Mua hàng',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
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
          );
  }

  int calculateTotal(List<ItemCart> items) {
    int total = 0;
    for (var item in items) {
      if (item.isCheckBox) {
        total += item.quantity * item.price;
      }
    }
    return total;
  }

  Widget _buildItemCartWidget(BuildContext context, ItemCart item, int index) {
    return ItemCartWidget(
      key: UniqueKey(),
      itemCart: item,
      onRemove: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Xác nhận"),
              content: const Text(
                  "Bạn có chắc chắn muốn xóa vật phẩm khỏi giỏ hàng không?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Không",
                      style: TextStyle(color: Color.fromARGB(255, 84, 84, 84))),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      items.removeAt(index);
                      total = calculateTotal(items);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Xóa",
                      style:
                          TextStyle(color: Color.fromARGB(255, 209, 87, 78))),
                ),
              ],
            );
          },
        );
      },
      onChanged: () {
        setState(() {
          total = calculateTotal(items);
        });
      },
    );
  }
}
