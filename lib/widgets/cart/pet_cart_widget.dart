import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/pet/model_pet_in_card.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class PetCartWidget extends StatelessWidget {
  final PetInCard petInCard;
  final VoidCallback onRemove;
  final formatter = NumberFormat("#,###", "vi_VN");

  PetCartWidget({super.key, required this.petInCard, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.2,
        children: [
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
                petInCard.imageUrl.toString(),
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
                    petInCard.name.toString().length > 30
                        ? '${petInCard.name.toString().substring(0, 30)}...'
                        : petInCard.name.toString(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    petInCard.shopName.toString().length > 20
                        ? '${petInCard.shopName.toString().substring(0, 20)}...'
                        : petInCard.shopName.toString(),
                    style: const TextStyle(
                        fontSize: 15, color: Color.fromARGB(255, 84, 84, 84)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${NumberFormat('#,##0', 'vi').format(petInCard.price)} đ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: priceColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: petInCard.inStock ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            petInCard.inStock ? '  Còn hàng  ' : '  Hết hàng  ',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
