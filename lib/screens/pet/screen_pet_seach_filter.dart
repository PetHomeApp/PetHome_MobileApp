import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/pet/model_pet_in_card.dart';
import 'package:pethome_mobileapp/screens/pet/screen_pet_detail.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/pet/pet_card.dart';

class PetSearchAndFilterScreen extends StatefulWidget {
  const PetSearchAndFilterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PetSearchAndFilterScreenState createState() =>
      _PetSearchAndFilterScreenState();
}

class _PetSearchAndFilterScreenState extends State<PetSearchAndFilterScreen> {
  List<PetInCard> pets = List.empty(growable: true);
  
  List<String> filterItems = [
    'Chó',
    'Mèo',
    'Chim',
    'Cá',
    'Thỏ',
    'Khác',
  ];

  Set<String> selectedFilters = {};

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Color.fromARGB(232, 255, 255, 255),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Search Information",
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.filter_alt,
                color: buttonBackgroundColor, size: 30),
            onPressed: () {
              scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          if (index % 2 == 0 && index < pets.length - 1) {
            return Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PetDetailScreen(
                          idPet: pets[index].idPet,
                        ),
                      ));
                    },
                    child: PetCard(petInCard: pets[index]),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PetDetailScreen(
                          idPet: pets[index].idPet,
                        ),
                      ));
                    },
                    child: PetCard(petInCard: pets[index + 1]),
                  ),
                ),
              ],
            );
          } else if (index == pets.length - 1) {
            return Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PetDetailScreen(
                          idPet: pets[index].idPet,
                        ),
                      ));
                    },
                    child: PetCard(petInCard: pets[index]),
                  ),
                ),
                Expanded(
                  child: Container(), // Phần trống
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: buttonBackgroundColor,
                ),
                child: Container(
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  alignment: Alignment.center,
                  child: const Text(
                    'Tìm kiếm theo loài',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: filterItems.map((filterItem) {
                    final isSelected = selectedFilters.contains(filterItem);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedFilters.remove(filterItem);
                          } else {
                            selectedFilters.add(filterItem);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? buttonBackgroundColor
                                : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          filterItem,
                          style: TextStyle(
                            color: isSelected
                                ? buttonBackgroundColor
                                : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const Divider(color: Colors.grey),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedFilters.clear();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 218, 217, 217),
                        border: Border.all(
                          color: buttonBackgroundColor,
                          width: 2,
                        ),
                      ),
                      child: const Text(
                        "Reset",
                        style: TextStyle(
                          color: buttonBackgroundColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                      decoration: BoxDecoration(
                        color: buttonBackgroundColor,
                        border: Border.all(
                          color: buttonBackgroundColor,
                          width: 2,
                        ),
                      ),
                      child: const Text(
                        "Apply",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
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
