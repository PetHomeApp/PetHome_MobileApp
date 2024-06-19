import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_cart.dart';
import 'package:pethome_mobileapp/model/user/model_user_address.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class BillItemCartScreen extends StatefulWidget {
  const BillItemCartScreen(
      {super.key, required this.itemCart, required this.userAddresses});
  final List<ItemCart> itemCart;
  final List<UserAddress> userAddresses;

  @override
  State<BillItemCartScreen> createState() => _BillItemCartScreenState();
}

class _BillItemCartScreenState extends State<BillItemCartScreen> {
  int amount = 0;
  int selectAddressIndex = 0;

  @override
  void initState() {
    super.initState();
    for (var item in widget.itemCart) {
      amount += item.price * item.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Thanh toán đơn hàng",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              ...widget.itemCart.map((item) {
                return Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            child: Image.network(
                              item.picture.toString(),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  'lib/assets/pictures/placeholder_image.png',
                                  height: 100,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name.toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${item.size} ${item.unit}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 84, 84, 84)),
                                ),
                                Text(
                                  item.shopName.toString(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 84, 84, 84)),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${NumberFormat('#,##0', 'vi').format(item.price)} đ',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: priceColor,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: item.inStock
                                              ? Colors.green
                                              : Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          item.inStock
                                              ? '  Còn hàng  '
                                              : '  Hết hàng  ',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: Text(
                                'Số lượng: ${item.quantity}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Địa chỉ nhận hàng',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.userAddresses.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: index,
                                  groupValue: selectAddressIndex,
                                  activeColor: buttonBackgroundColor,
                                  onChanged: (value) {
                                    setState(() {
                                      selectAddressIndex = value as int;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.userAddresses[index].address
                                            .toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
              flex: 15,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Tổng tiền: ${NumberFormat('#,##0', 'vi').format(amount)} đ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: priceColor,
                  ),
                ),
              )),
          Expanded(
            flex: 10,
            child: InkWell(
              onTap: () async {},
              child: Container(
                color: buttonBackgroundColor,
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.payment,
                        color: Colors.white,
                      ),
                      Text(
                        'Thanh toán',
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
