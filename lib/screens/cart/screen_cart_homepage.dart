import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/item/model_item_cart.dart';
import 'package:pethome_mobileapp/model/pet/model_pet_cart.dart';
import 'package:pethome_mobileapp/screens/item/screen_item_detail.dart';
import 'package:pethome_mobileapp/screens/pet/screen_pet_detail.dart';
import 'package:pethome_mobileapp/services/api/cart_api.dart';
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

  int countPetsCart = 0;
  int countItemsCart = 0;

  List<PetCart> pets = List.empty(growable: true);
  List<ItemCart> items = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    getListPetsAndItemsCart();
  }

  Future<void> getListPetsAndItemsCart() async {
    if (loading) {
      return;
    }

    loading = true;
    final dataResPet = await CartApi().getListPetsCart();
    final dataResItem = await CartApi().getListItemsCart();

    if (dataResPet['isSuccess'] == false) {
      loading = false;
      return;
    }

    if (dataResItem['isSuccess'] == false) {
      loading = false;
      return;
    }

    setState(() {
      pets = dataResPet['pets'];
      countPetsCart = dataResPet['countPets'];

      items = dataResItem['items'];
      countItemsCart = dataResItem['countItems'];

      loading = false;
    });
  }

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
                    child: TabBar(
                      indicatorColor: buttonBackgroundColor,
                      labelColor: buttonBackgroundColor,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(text: 'Thú cưng ($countPetsCart)'),
                        Tab(text: 'Vật phẩm ($countItemsCart)'),
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
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PetDetailScreen(
                                    idPet: pets[index].idPet,
                                    showCartIcon: false)));
                          },
                          child: PetCartWidget(
                            petCart: pets[index],
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
                                            countPetsCart--;
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
                          ),
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
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ItemDetailScreen(
                                          idItem: items[index].idItem,
                                          showCartIcon: false)));
                                },
                                child: Column(
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
                                ),
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
                      countItemsCart--;
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
