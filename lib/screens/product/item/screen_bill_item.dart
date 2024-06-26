import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/payment/model_payment_method.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_classify.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_detail.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_sent_bill.dart';
import 'package:pethome_mobileapp/model/user/model_user_address.dart';
import 'package:pethome_mobileapp/services/api/bill_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class BillItemScreen extends StatefulWidget {
  const BillItemScreen(
      {super.key,
      required this.itemDetail,
      required this.itemClassify,
      required this.userAddresses});

  final ItemDetail itemDetail;
  final DetailItemClassify itemClassify;
  final List<UserAddress> userAddresses;

  @override
  State<BillItemScreen> createState() => _BillItemScreenState();
}

class _BillItemScreenState extends State<BillItemScreen> {
  late TextEditingController _controller;
  final TextEditingController _phoneController = TextEditingController();

  late List<PaymentMethod> paymentMethods;

  int selectAddressIndex = 0;
  int selectPaymentMethodIndex = 0;

  bool loading = false;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '$quantity');
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

  void _incrementCounter() {
    setState(() {
      quantity++;
      _controller.text = '$quantity';
    });
  }

  void _decrementCounter() {
    setState(() {
      if (quantity > 1) {
        quantity--;
        _controller.text = '$quantity';
      }
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
                    Container(
                      color: Colors.grey[100],
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                child: Image.network(
                                  widget.itemDetail.imageUrl.toString(),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.itemDetail.name.toString(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${widget.itemClassify.size} ${widget.itemDetail.unit}   -   Còn lại: ${widget.itemClassify.quantity} sản phẩm',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromARGB(255, 84, 84, 84)),
                                    ),
                                    Text(
                                      widget.itemDetail.shop.name.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 84, 84, 84)),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${NumberFormat('#,##0', 'vi').format(widget.itemClassify.price)} đ',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: priceColor,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: widget.itemClassify.instock
                                                  ? Colors.green
                                                  : Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              widget.itemClassify.instock
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
                                const Padding(
                                  padding: EdgeInsets.only(left: 15, top: 10),
                                  child: Text(
                                    'Số lượng:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      _buildSquareButton(
                                          '-', _decrementCounter),
                                      _buildSquareTextField(),
                                      _buildSquareButton(
                                          '+', _incrementCounter),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Số điện thoại người nhận',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            cursorColor: buttonBackgroundColor,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 0.75,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 0.75,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                  color: buttonBackgroundColor,
                                  width: 1.0,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 12.0),
                              hintText: 'Nhập số điện thoại người nhận',
                            ),
                          ),
                        ],
                      ),
                    ),
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
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Phương thức thanh toán',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                                        groupValue: selectPaymentMethodIndex,
                                        activeColor: buttonBackgroundColor,
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
                        'Tổng tiền: ${NumberFormat('#,##0', 'vi').format(widget.itemClassify.price * quantity)} đ',
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
                      if (quantity > widget.itemClassify.quantity) {
                        showTopSnackBar(
                          // ignore: use_build_context_synchronously
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message: 'Số lượng sản phẩm không đủ',
                          ),
                          displayDuration: const Duration(seconds: 0),
                        );
                        return;
                      }

                      if (_phoneController.text == '') {
                        showTopSnackBar(
                          // ignore: use_build_context_synchronously
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message: 'Vui lòng nhập số điện thoại người nhận',
                          ),
                          displayDuration: const Duration(seconds: 0),
                        );
                        return;
                      }

                      var response = await BillApi().sentBill([
                        ItemSentBill(
                            itemId: widget.itemDetail.idItem,
                            itemDetailId: widget.itemClassify.idItemDetail,
                            quantity: quantity),
                      ],
                          _phoneController.text,
                          widget.userAddresses[selectAddressIndex].address,
                          widget.userAddresses[selectAddressIndex].area,
                          paymentMethods[selectPaymentMethodIndex].idMethod);

                      if (response['isSuccess'] == true) {
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
                            message: 'Đặt hàng thất bại, vui lòng thử lại sau',
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
                              'Đặt hàng',
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

  Widget _buildSquareButton(String label, VoidCallback onPressed) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Center(
          child: Text(label, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildSquareTextField() {
    return Container(
      width: 50,
      height: 30,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black),
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      alignment: Alignment.center,
      child: Center(
        child: TextField(
          controller: _controller,
          cursorColor: buttonBackgroundColor,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 6.0),
          ),
          onSubmitted: (value) {
            setState(() {
              quantity = int.tryParse(value) ?? 1;
              _controller.text = '$quantity';
            });
          },
        ),
      ),
    );
  }
}
