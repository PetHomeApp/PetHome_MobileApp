import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_in_card.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class ServiceActiveOfShopWidget extends StatelessWidget {
  final ServiceInCard serviceInCard;
  final VoidCallback onRemove;
  final VoidCallback onEdit;
  final formatter = NumberFormat("#,###", "vi_VN");

  ServiceActiveOfShopWidget(
      {super.key,
      required this.serviceInCard,
      required this.onRemove,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.6,
        children: [
          SlidableAction(
            onPressed: (context) {
              onEdit();
            },
            icon: Icons.edit,
            label: "Chỉnh sửa",
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
          SlidableAction(
            onPressed: (context) {
              onRemove();
            },
            icon: Icons.delete,
            label: "Xóa",
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: Card(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                serviceInCard.picture.toString(),
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
              child: SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        serviceInCard.serviceName.toString(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${NumberFormat('#,##0', 'vi').format(serviceInCard.minPrice)} đ - ${NumberFormat('#,##0', 'vi').format(serviceInCard.maxPrice)} đ',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: priceColor,
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
