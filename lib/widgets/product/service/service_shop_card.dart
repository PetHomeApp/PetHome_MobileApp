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
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
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
              const SizedBox(height: 15),
              Text(
                '${formatter.format(serviceInCard.minPrice)}đ - ${formatter.format(serviceInCard.maxPrice)}đ',
                style: const TextStyle(
                    fontSize: 16,
                    color: priceColor,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
