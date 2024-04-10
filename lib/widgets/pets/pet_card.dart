import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class Pet {
  final String name;
  final String imageUrl;
  final String shopName;
  final double price;

  Pet(
      {required this.name,
      required this.imageUrl,
      required this.shopName,
      required this.price});
}

class PetCard extends StatelessWidget {
  final Pet pet;
  const PetCard({super.key, required this.pet});

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
                  pet.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                pet.name.length > 20
                    ? '${pet.name.substring(0, 20)}...'
                    : pet.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              Text(
                pet.shopName.length > 20
                    ? '${pet.shopName.substring(0, 20)}...'
                    : pet.shopName,
                style: const TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 84, 84, 84)),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 8),
              Text(
                '\$${pet.price.toStringAsFixed(2)}',
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
