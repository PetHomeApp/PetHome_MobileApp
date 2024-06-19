import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/payment/model_payment_method.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_cart.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_sent_bill.dart';
import 'package:pethome_mobileapp/model/user/model_user_address.dart';
import 'package:pethome_mobileapp/services/api/bill_api.dart';
import 'package:pethome_mobileapp/services/api/cart_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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
  int selectPaymentMethodIndex = 0;

  late List<PaymentMethod> paymentMethods;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    for (var item in widget.itemCart) {
      amount += item.price * item.quantity;
    }
    getPaymentMethod();
  }

  void getPaymentMethod() async {
    setState(() {
      loading = true;
    });
    paymentMethods = await BillApi().getPaymentMethod();
    setState(() {
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
        : Scaffold(
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
                                        Object exception,
                                        StackTrace? stackTrace) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            color: Color.fromARGB(
                                                255, 84, 84, 84)),
                                      ),
                                      Text(
                                        item.shopName.toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Color.fromARGB(
                                                255, 84, 84, 84)),
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
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
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
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10),
                                    child: Text(
                                      'Số lượng: ${item.quantity}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
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
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                                              widget
                                                  .userAddresses[index].address
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 16),
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
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Phương thức thanh toán',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: paymentMethods.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Radio(
                                              value: index,
                                              groupValue:
                                                  selectPaymentMethodIndex,
                                              activeColor:
                                                  buttonBackgroundColor,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectPaymentMethodIndex =
                                                      value as int;
                                                });
                                              },
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    paymentMethods[index]
                                                        .description
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16),
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
                    onTap: () async {
                      List<ItemSentBill> listItemBill = [];
                      for (var item in widget.itemCart) {
                        listItemBill.add(ItemSentBill(
                            itemId: item.idItem,
                            itemDetailId: item.idItemDetail,
                            quantity: item.quantity));
                      }
                      var response = await BillApi().sentBill(
                          listItemBill,
                          widget.userAddresses[selectAddressIndex].address,
                          widget.userAddresses[selectAddressIndex].area,
                          paymentMethods[selectPaymentMethodIndex].idMethod);

                      if (response['isSuccess'] == true) {
                        for (var item in widget.itemCart) {
                          await CartApi().deleteItemInCart(item.idItemDetail);
                        }
                        showTopSnackBar(
                          // ignore: use_build_context_synchronously
                          Overlay.of(context),
                          const CustomSnackBar.success(
                            message: 'Đặt hàng thành công',
                          ),
                          displayDuration: const Duration(seconds: 0),
                        );
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      } else {
                        showTopSnackBar(
                          // ignore: use_build_context_synchronously
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message:
                                'Đặt hàng thất bại, số lượng đặt quá lớn, vui lòng thử lại sau',
                          ),
                          displayDuration: const Duration(seconds: 0),
                        );
                      }
                    },
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
