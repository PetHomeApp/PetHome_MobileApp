import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/bill/model_bill.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class ShopBillDetailScreen extends StatefulWidget {
  const ShopBillDetailScreen({super.key, required this.billItem});
  final BillItem billItem;

  @override
  State<ShopBillDetailScreen> createState() => _ShopBillDetailScreenState();
}

class _ShopBillDetailScreenState extends State<ShopBillDetailScreen> {
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
          "Chi tiết đơn hàng",
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        child: Image.network(
                          widget.billItem.itemImage.toString(),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
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
                              widget.billItem.itemName.toString(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        const Text('Trạng thái: ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Text(
                            widget.billItem.status == 'pending'
                                ? 'Chưa nhận đơn'
                                : widget.billItem.status == 'preparing'
                                    ? 'Dã nhận đơn'
                                    : widget.billItem.status == 'delivering'
                                        ? 'Đang giao hàng'
                                        : widget.billItem.status == 'delivered'
                                            ? 'Đã giao hàng'
                                            : widget.billItem.status == 'done'
                                                ? 'Đã hoàn thành'
                                                : 'Đã hủy',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: widget.billItem.status == 'pending'
                                    ? const Color.fromARGB(255, 255, 38, 0)
                                    : widget.billItem.status == 'preparing'
                                        ? buttonBackgroundColor
                                        : widget.billItem.status == 'delivering'
                                            ? buttonBackgroundColor
                                            : widget.billItem.status ==
                                                    'delivered'
                                                ? Colors.green
                                                : widget.billItem.status ==
                                                        'done'
                                                    ? Colors.green
                                                    : Colors.red)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Đơn vị tính: ${widget.billItem.itemSize} ${widget.billItem.itemUnit}',
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text('Số lượng: ${widget.billItem.quantity}',
                            style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        Text(
                            'Đơn giá: ${NumberFormat('#,##0', 'vi').format(widget.billItem.price)} đ',
                            style: const TextStyle(
                                fontSize: 18,
                                color: priceColor,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(
                            'Tổng tiền: ${NumberFormat('#,##0', 'vi').format(widget.billItem.totalPrice)}  đ',
                            style: const TextStyle(
                                fontSize: 18,
                                color: priceColor,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.date_range,
                              color: buttonBackgroundColor,
                              size: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Thời gian đặt hàng:',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: buttonBackgroundColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                            '${DateFormat('HH:mm').format(DateTime.parse(widget.billItem.createdAt).add(const Duration(hours: 7)))} ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.billItem.createdAt).add(const Duration(hours: 7)))}',
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 84, 84, 84))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.person,
                              color: buttonBackgroundColor,
                              size: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Tên người đặt:',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: buttonBackgroundColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(widget.billItem.userName,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 84, 84, 84))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.phone,
                              color: buttonBackgroundColor,
                              size: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Số điện thoại nhận hàng:',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: buttonBackgroundColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(widget.billItem.phoneNumber,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 84, 84, 84))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: buttonBackgroundColor,
                              size: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Địa chỉ nhận hàng:',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: buttonBackgroundColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(widget.billItem.address,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 84, 84, 84))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.payment,
                              color: buttonBackgroundColor,
                              size: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Phương thức thanh toán:',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: buttonBackgroundColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(widget.billItem.paymentMethod,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 84, 84, 84))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.ads_click_rounded,
                              color: buttonBackgroundColor,
                              size: 25,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Tình trạng thanh toán:',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: buttonBackgroundColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                            widget.billItem.paymentStatus == 'pending'
                                ? 'Chưa thanh toán'
                                : 'Đã thanh toán',
                            style: TextStyle(
                              fontSize: 18,
                              color: widget.billItem.paymentStatus == 'pending'
                                  ? Colors.red
                                  : buttonBackgroundColor,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
