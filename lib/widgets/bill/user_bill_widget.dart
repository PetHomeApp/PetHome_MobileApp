import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/bill/model_bill.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class UserBillWidget extends StatelessWidget {
  final BillItem billItem;
  final VoidCallback onPayment;
  final VoidCallback onCancel;

  const UserBillWidget(
      {super.key,
      required this.billItem,
      required this.onPayment,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return billItem.paymentStatus == 'pending' &&
            billItem.paymentMethod == 'Ví điện tử VNPAY'
        ? Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.6,
              children: [
                SlidableAction(
                  onPressed: (context) {
                    onPayment();
                  },
                  icon: Icons.edit,
                  label: "Thanh toán",
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
                SlidableAction(
                  onPressed: (context) {
                    onCancel();
                  },
                  icon: Icons.delete,
                  label: "Hủy đơn",
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
              ],
            ),
            child: _buildBillWiget(billItem),
          )
        : billItem.status == 'pending'
            ? Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.3,
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        onCancel();
                      },
                      icon: Icons.delete,
                      label: "Hủy đơn",
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                  ],
                ),
                child: _buildBillWiget(billItem),
              )
            : _buildBillWiget(billItem);
  }

  _buildBillWiget(BillItem billItem) {
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
                                  : 'Đã giao hàng',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: billItem.status == 'pending'
                              ? const Color.fromARGB(255, 255, 38, 0)
                              : billItem.status == 'preparing'
                                  ? buttonBackgroundColor
                                  : billItem.status == 'delivering'
                                      ? buttonBackgroundColor
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
