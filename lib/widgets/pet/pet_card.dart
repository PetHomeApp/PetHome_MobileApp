import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/pet/model_pet_in_card.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class PetCard extends StatelessWidget {
  final PetInCard petInCard;
  final formatter = NumberFormat("#,###", "vi_VN");

  PetCard({super.key, required this.petInCard});

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
                child: FadeInImage(
                  placeholder: const AssetImage(
                      'lib/assets/pictures/placeholder_image.png'),
                  image: NetworkImage(petInCard.imageUrl.toString()),
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                petInCard.name.toString().length > 20
                    ? '${petInCard.name.toString().substring(0, 20)}...'
                    : petInCard.name.toString(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              Text(
                petInCard.shopName.toString().length > 20
                    ? '${petInCard.shopName.toString().substring(0, 20)}...'
                    : petInCard.shopName.toString(),
                style: const TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 84, 84, 84)),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 8),
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
      ),
    );
  }
}
