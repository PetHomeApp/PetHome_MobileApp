import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/bill/model_bill.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class UserBillWidgetNoInteract extends StatelessWidget {
  final BillItem billItem;

  const UserBillWidgetNoInteract({super.key, required this.billItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                child: Image.network(
                  billItem.itemImage.toString(),
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
                      billItem.itemName.toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      billItem.shopName,
                      style: const TextStyle(
                          fontSize: 14, color: Color.fromARGB(255, 84, 84, 84)),
                    ),
                    Text(
                      'Ngày đặt: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(billItem.createdAt).add(const Duration(hours: 7)))}',
                      style: const TextStyle(
                          fontSize: 14, color: Color.fromARGB(255, 84, 84, 84)),
                    ),
                    Text(
                      'Tổng cộng: ${NumberFormat('#,##0', 'vi').format(billItem.totalPrice)} đ',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: priceColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${billItem.paymentMethod}  -  ',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: buttonBackgroundColor),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          billItem.paymentStatus == 'pending'
                              ? 'Chưa thanh toán'
                              : 'Đã thanh toán',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: billItem.paymentStatus == 'pending'
                                  ? Colors.red
                                  : buttonBackgroundColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      billItem.status == 'pending'
                          ? 'Chưa nhận đơn'
                          : billItem.status == 'preparing'
                              ? 'Đã nhận đơn'
                              : billItem.status == 'delivering'
                                  ? 'Đang giao hàng'
                                  : billItem.status == 'delivered'
                                      ? 'Đã giao hàng'
                                      : billItem.status == 'done'
                                          ? 'Đã hoàn thành'
                                          : 'Đã hủy',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: billItem.status == 'pending'
                              ? const Color.fromARGB(255, 255, 38, 0)
                              : billItem.status == 'preparing'
                                  ? buttonBackgroundColor
                                  : billItem.status == 'delivering'
                                      ? buttonBackgroundColor
                                      : billItem.status == 'cancelled'
                                          ? Colors.red
                                          : Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
