import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/bill/model_bill.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class ShopNewBillWidget extends StatelessWidget {
  final BillItem billItem;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  const ShopNewBillWidget(
      {super.key,
      required this.billItem,
      required this.onConfirm,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.6,
        children: [
          SlidableAction(
            onPressed: (context) {
              onConfirm();
            },
            icon: Icons.edit,
            label: "Nhận đơn",
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
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
                        const SizedBox(height: 2),
                        Text(
                          'Ngày đặt: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(billItem.createdAt).add(const Duration(hours: 7)))}',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 84, 84, 84)),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Tổng cộng: ${NumberFormat('#,##0', 'vi').format(billItem.totalPrice)} đ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: priceColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Đang chờ xác nhận',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 38, 0)),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
