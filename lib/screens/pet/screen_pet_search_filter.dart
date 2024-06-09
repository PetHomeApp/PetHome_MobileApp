import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_age.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_in_card.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_spiece.dart';
import 'package:pethome_mobileapp/screens/pet/screen_pet_detail.dart';
import 'package:pethome_mobileapp/services/api/pet_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/setting/list_area.dart';
import 'package:pethome_mobileapp/widgets/product/pet/pet_card.dart';

class PetSearchAndFilterScreen extends StatefulWidget {
  const PetSearchAndFilterScreen({super.key, required this.title});

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _PetSearchAndFilterScreenState createState() =>
      _PetSearchAndFilterScreenState();
}

class _PetSearchAndFilterScreenState extends State<PetSearchAndFilterScreen> {
  List<PetInCard> listPetsInCard = List.empty(growable: true);
  List<PetInCard> listPetsFilter = List.empty(growable: true);

  List<PetSpecie> petSpecie = List.empty(growable: true);
  List<PetAge> petAge = List.empty(growable: true);

  List<String> filterSpecie = [];
  List<String> filterAge = [];
  List<String> filterArea = area;

  Set<String> selectedSpecieFilters = {};
  Set<String> selectedAgeFilters = {};
  Set<String> selectedAreaFilters = {};

  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool showAll = false;

  bool loading = false;
  int currentPage = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listenerScroll);

    getListPetInCards();

    PetApi().getPetSpecies().then((value) {
      setState(() {
        petSpecie = value;
        filterSpecie = petSpecie.map((e) => e.name).toList();
      });
    });

    PetApi().getPetAges().then((value) {
      setState(() {
        petAge = value;
        filterAge = petAge.map((e) => e.name).toList();
      });
    });
  }

  void _listenerScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        getListPetInCards();
      }
    }
  }

  Future<void> getListPetInCards() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<PetInCard> pets =
        await PetApi().searchPetsInCard(widget.title, 10, currentPage * 10);

    if (pets.isEmpty) {
      loading = false;
      return;
    }

    setState(() {
      listPetsInCard.addAll(pets);
      if (selectedSpecieFilters.isEmpty &&
          selectedAgeFilters.isEmpty &&
          selectedAreaFilters.isEmpty) {
        listPetsFilter.addAll(pets);
      } else {
        List<PetInCard> addFilterList = List.empty(growable: true);
        addFilterList = pets.where((pet) {
          PetSpecie petSpecieItem = petSpecie.firstWhere(
              (element) => element.id == pet.specieID,
              orElse: () => PetSpecie(id: 0, name: ''));
          PetAge petAgeItem = petAge.firstWhere(
              (element) => element.id == pet.ageID,
              orElse: () => PetAge(id: 0, name: ''));
          if ((selectedSpecieFilters.isEmpty ||
                  selectedSpecieFilters.contains(petSpecieItem.name)) &&
              (selectedAgeFilters.isEmpty ||
                  selectedAgeFilters.contains(petAgeItem.name)) &&
              (selectedAreaFilters.isEmpty ||
                  selectedAreaFilters
                      .any((element) => pet.areas!.contains(element)))) {
            return true;
          }
          return false;
        }).toList();
        listPetsFilter.addAll(addFilterList);
      }

      currentPage++;
      loading = false;
    });
  }

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
        title: Text(
          widget.title,
          style: const TextStyle(
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
            icon:
                const Icon(Icons.filter_alt, color: iconButtonColor, size: 30),
            onPressed: () {
              scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(buttonBackgroundColor),
              ),
            )
          : listPetsFilter.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 50,
                        color: buttonBackgroundColor,
                      ),
                      Text(
                        'Không có kết quả tìm kiếm phù hợp!',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: buttonBackgroundColor),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  controller: _scrollController,
                  itemCount: listPetsFilter.length,
                  itemBuilder: (context, index) {
                    if (index % 2 == 0 && index < listPetsFilter.length - 1) {
                      return Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PetDetailScreen(
                                    idPet: listPetsFilter[index].idPet,
                                    showCartIcon: true,
                                  ),
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 4.0,
                                    top: 4.0,
                                    bottom: 4.0),
                                child:
                                    PetCard(petInCard: listPetsFilter[index]),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PetDetailScreen(
                                    idPet: listPetsFilter[index + 1].idPet,
                                    showCartIcon: true,
                                  ),
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 4.0,
                                    right: 8.0,
                                    top: 4.0,
                                    bottom: 4.0),
                                child: PetCard(
                                    petInCard: listPetsFilter[index + 1]),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (index % 2 == 0 &&
                        index == listPetsFilter.length - 1) {
                      return Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PetDetailScreen(
                                    idPet: listPetsFilter[index].idPet,
                                    showCartIcon: true,
                                  ),
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 4.0,
                                    top: 4.0,
                                    bottom: 4.0),
                                child:
                                    PetCard(petInCard: listPetsFilter[index]),
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
                  },
                ),
      endDrawer: FractionallySizedBox(
        widthFactor: 0.85,
        // ignore: deprecated_member_use
        child: WillPopScope(
          onWillPop: () async => false,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 150,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: buttonBackgroundColor,
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      alignment: Alignment.center,
                      child: const Text(
                        'Bộ lọc tìm kiếm',
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text('Loại thú cưng: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: filterSpecie.map((filterItem) {
                                final isSelected =
                                    selectedSpecieFilters.contains(filterItem);
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedSpecieFilters
                                            .remove(filterItem);
                                      } else {
                                        selectedSpecieFilters.add(filterItem);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                        const Text('Tuổi: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: filterAge.map((filterItem) {
                                    final isSelected =
                                        selectedAgeFilters.contains(filterItem);
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            selectedAgeFilters
                                                .remove(filterItem);
                                          } else {
                                            selectedAgeFilters.add(filterItem);
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 10, 5),
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
                              ],
                            ),
                          ),
                        ),
                        const Divider(color: Colors.grey),
                        const Text('Khu vực: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: filterArea
                                      .asMap()
                                      .entries
                                      .where(
                                          (entry) => showAll || entry.key < 5)
                                      .map((entry) {
                                    final filterItem = entry.value;
                                    final isSelected = selectedAreaFilters
                                        .contains(filterItem);
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            selectedAreaFilters
                                                .remove(filterItem);
                                          } else {
                                            selectedAreaFilters.add(filterItem);
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 10, 5),
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
                                if (filterArea.length > 5)
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          showAll = !showAll;
                                        });
                                      },
                                      child: Text(
                                        showAll ? 'Thu gọn' : 'Mở rộng',
                                        style: const TextStyle(
                                            color: buttonBackgroundColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                buttonBackgroundColor,
                                            decorationThickness: 2),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                            selectedSpecieFilters.clear();
                            selectedAgeFilters.clear();
                            selectedAreaFilters.clear();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 249, 249, 249),
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
                          setState(() {
                            listPetsFilter = listPetsInCard.where((pet) {
                              if (selectedSpecieFilters.isEmpty &&
                                  selectedAgeFilters.isEmpty &&
                                  selectedAreaFilters.isEmpty) {
                                return true;
                              }
                              PetSpecie petSpecieItem = petSpecie.firstWhere(
                                  (element) => element.id == pet.specieID,
                                  orElse: () => PetSpecie(id: 0, name: ''));
                              PetAge petAgeItem = petAge.firstWhere(
                                  (element) => element.id == pet.ageID,
                                  orElse: () => PetAge(id: 0, name: ''));
                              if ((selectedSpecieFilters.isEmpty ||
                                      selectedSpecieFilters
                                          .contains(petSpecieItem.name)) &&
                                  (selectedAgeFilters.isEmpty ||
                                      selectedAgeFilters
                                          .contains(petAgeItem.name)) &&
                                  (selectedAreaFilters.isEmpty ||
                                      selectedAreaFilters.any((element) =>
                                          pet.areas!.contains(element)))) {
                                return true;
                              }
                              return false;
                            }).toList();
                            Navigator.of(context).pop();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
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
        ),
      ),
    );
  }
}
