import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/screens/my/screen_notification.dart';
import 'package:pethome_mobileapp/screens/product/service/screen_list_service.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/product/service/service_card.dart';

class ServiceHomeScreen extends StatefulWidget {
  final ValueNotifier<int> counterNotifier;
  const ServiceHomeScreen({super.key, required this.counterNotifier});

  @override
  State<ServiceHomeScreen> createState() => _ServiceHomeScreenState();
}

class _ServiceHomeScreenState extends State<ServiceHomeScreen> {
  List<Map<String, dynamic>> categories = [
    {
      'id': 1,
      'name': 'Spa cho thú cưng',
      'title': 'Spa cho thú cưng',
      'image': 'lib/assets/pictures/pet_spa_image.png',
    },
    {
      'id': 2,
      'name': 'Y tế - Chăm sóc sức khỏe',
      'title': 'Y tế - Chăm sóc sức khỏe',
      'image': 'lib/assets/pictures/healthcare_image.png',
    },
    {
      'id': 3,
      'name': 'Huấn luyện thú cưng',
      'title': 'Huấn luyện\n thú cưng',
      'image': 'lib/assets/pictures/pet_training_image.png',
    },
    {
      'id': 100,
      'name': 'Dịch vụ khác',
      'title': 'Dịch vụ khác',
      'image': 'lib/assets/pictures/other_services_image.png',
    },
  ];

  int countNotification = 0;

  @override
  void initState() {
    super.initState();
    countNotification = widget.counterNotifier.value;
    widget.counterNotifier.addListener(_updateCounter);
  }

  @override
  void dispose() {
    widget.counterNotifier.removeListener(_updateCounter);
    super.dispose();
  }

  void _updateCounter() {
    setState(() {
      countNotification = widget.counterNotifier.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Dịch vụ thú cưng",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Stack(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ));
                  },
                  icon: const Icon(
                    Icons.notifications,
                    size: 30,
                    color: iconButtonColor,
                  ),
                ),
                if (countNotification > 0)
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        countNotification.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            )
          ],
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
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ListServiceScreen(
                              idServiceType: categories[index]['id'],
                              title: categories[index]['name']),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 4, bottom: 4, left: 8, top: 8),
                        child: ServiceCard(
                          title: categories[index]['title'],
                          image: categories[index]['image'],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ListServiceScreen(
                              idServiceType: categories[index + 1]['id'],
                              title: categories[index + 1]['name']),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 8, bottom: 4, left: 4, top: 8),
                        child: ServiceCard(
                          title: categories[index + 1]['title'],
                          image: categories[index + 1]['image'],
                        ),
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
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ListServiceScreen(
                              idServiceType: categories[index]['id'],
                              title: categories[index]['name']),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 4, bottom: 4, left: 8, top: 8),
                        child: ServiceCard(
                          title: categories[index]['title'],
                          image: categories[index]['image'],
                        ),
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
