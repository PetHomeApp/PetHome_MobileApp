import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_in_card.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class ServiceShopCard extends StatelessWidget {
  final ServiceInCard serviceInCard;
  final formatter = NumberFormat("#,###", "vi_VN");

  ServiceShopCard({super.key, required this.serviceInCard});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4, top: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                serviceInCard.serviceName.toString(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                serviceInCard.areas.join(', ').toString(),
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 5),
              Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 12,
                    ),
                    Text(
                      serviceInCard.avgRating == 0
                          ? '0.0/0.0'
                          : '${serviceInCard.avgRating.toStringAsFixed(1)}/5.0',
                      style: const TextStyle(
                          fontSize: 14, color: Colors.amber, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              Text(
                '${formatter.format(serviceInCard.minPrice)}đ - ${formatter.format(serviceInCard.maxPrice)}đ',
                style: const TextStyle(
                    fontSize: 18,
                    color: priceColor,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
