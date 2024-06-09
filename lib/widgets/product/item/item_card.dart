import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_in_card.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class ItemCard extends StatelessWidget {
  final ItemInCard itemInCard;
  final formatter = NumberFormat("#,###", "vi_VN");

  ItemCard({super.key, required this.itemInCard});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            child: Image.network(
              itemInCard.imageUrl.toString(),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Image.asset(
                  'lib/assets/pictures/placeholder_image.png',
                  height: 150,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemInCard.name.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  itemInCard.shopName.toString(),
                  style: const TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 84, 84, 84)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
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
        ],
      ),
    );
  }
}
