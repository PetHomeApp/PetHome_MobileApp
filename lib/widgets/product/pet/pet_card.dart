import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_in_card.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class PetCard extends StatelessWidget {
  final PetInCard petInCard;
  final formatter = NumberFormat("#,###", "vi_VN");

  PetCard({super.key, required this.petInCard});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            child: Image.network(
              petInCard.imageUrl.toString(),
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
                  petInCard.name.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  petInCard.shopName.toString(),
                  style: const TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 84, 84, 84)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  '${formatter.format(petInCard.price)} đ',
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
