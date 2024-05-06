import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/service/service_card.dart';

class ServiceHomeScreen extends StatefulWidget {
  const ServiceHomeScreen({super.key});

  @override
  State<ServiceHomeScreen> createState() => _ServiceHomeScreenState();
}

class _ServiceHomeScreenState extends State<ServiceHomeScreen> {
  List<Map<String, dynamic>> categories = [
    {
      'title': 'Spa cho thú cưng',
      'image': 'lib/assets/pictures/pet_spa_image.png',
    },
    {
      'title': 'Y tế - Chăm sóc sức khỏe',
      'image': 'lib/assets/pictures/healthcare_image.png',
    },
    {
      'title': 'Huấn luyện\n thú cưng',
      'image': 'lib/assets/pictures/pet_training_image.png',
    },
    {
      'title': 'Dịch vụ khác',
      'image': 'lib/assets/pictures/other_services_image.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dịch vụ thú cưng - PetHome",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [gradientStartColor, gradientMidColor, gradientEndColor],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          if (index < categories.length) {
            if (index % 2 == 0 && index < categories.length - 1) {
              return Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        
                      },
                      child: ServiceCard(
                        title: categories[index]['title'],
                        image: categories[index]['image'],
                        
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () { },
                      child: ServiceCard(
                        title: categories[index + 1]['title'],
                        image: categories[index + 1]['image'],
                      ),
                    ),
                  ),
                ],
              );
            } else if (index % 2 == 0 && index == categories.length - 1) {
              return Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        
                      },
                      child: ServiceCard(
                        title: categories[index]['title'],
                        image: categories[index]['image'],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }
          return null;
        },
      ),
    );
  }
  
}

