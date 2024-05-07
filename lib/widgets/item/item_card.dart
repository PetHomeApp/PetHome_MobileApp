import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/item/model_item_in_card.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class ItemCart extends StatelessWidget {
  final ItemInCard itemInCard;
  final formatter = NumberFormat("#,###", "vi_VN");

  ItemCart({super.key, required this.itemInCard});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  itemInCard.imageUrl.toString(),
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    if (exception is HandshakeException) {
                      return Image.asset('lib/assets/pictures/placeholder_image.png', height: 150, width: double.infinity, fit: BoxFit.cover);
                    } else {
                      return const SizedBox(
                        height: 150,
                        child: Text('Something went wrong...'),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                itemInCard.name.toString().length > 20
                    ? '${itemInCard.name.toString().substring(0, 20)}...'
                    : itemInCard.name.toString(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              Text(
                itemInCard.shopName.toString().length > 20
                    ? '${itemInCard.shopName.toString().substring(0, 20)}...'
                    : itemInCard.shopName.toString(),
                style: const TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 84, 84, 84)),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 8),
              Text(
                '${formatter.format(itemInCard.minPrice)} đ',
                style: const TextStyle(
                    fontSize: 16,
                    color: priceColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}