import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_age.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_in_card.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_spiece.dart';
import 'package:pethome_mobileapp/screens/shop/managershop/manager/pet/screen_pet_infor.dart';
import 'package:pethome_mobileapp/screens/shop/managershop/manager/pet/screen_update_pet.dart';
import 'package:pethome_mobileapp/services/api/pet_api.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/product/pet/pet_active_of_shop.dart';
import 'package:pethome_mobileapp/widgets/shop/product/pet/pet_request_of_shop.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SearchShopPetScreen extends StatefulWidget {
  const SearchShopPetScreen(
      {super.key, required this.title, required this.shopId});

  final String shopId;
  final String title;

  @override
  State<SearchShopPetScreen> createState() => _SearchShopPetScreenState();
}

class _SearchShopPetScreenState extends State<SearchShopPetScreen>
    with TickerProviderStateMixin {
  List<PetInCard> listPetActiveInCards = List.empty(growable: true);
  List<PetInCard> listPetRequestInCards = List.empty(growable: true);

  List<PetInCard> listPetActiveFilter = List.empty(growable: true);
  List<PetInCard> listPetRequestFilter = List.empty(growable: true);

  List<PetSpecie> petSpecie = List.empty(growable: true);
  List<PetAge> petAge = List.empty(growable: true);

  List<String> filterSpecie = [];
  List<String> filterAge = [];

  Set<String> selectedSpecieFilters = {};
  Set<String> selectedAgeFilters = {};

  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool showAll = false;

  int currentPageActive = 0;
  int currentPageRequest = 0;

  bool loadingActive = false;
  bool loadingRequest = false;

  final ScrollController _scrollActiveController = ScrollController();
  final ScrollController _scrollRequestController = ScrollController();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollActiveController.addListener(_listenerActiveScroll);
    _scrollRequestController.addListener(_listenerRequestScroll);
    _tabController = TabController(length: 2, vsync: this);

    getListPetActiveInShop();
    getListPetRequiredInShop();

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

  @override
  void dispose() {
    _scrollActiveController.dispose();
    _scrollRequestController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _listenerActiveScroll() {
    if (_scrollActiveController.position.atEdge) {
      if (_scrollActiveController.position.pixels != 0) {
        getListPetActiveInShop();
      }
    }
  }

  void _listenerRequestScroll() {
    if (_scrollRequestController.position.atEdge) {
      if (_scrollRequestController.position.pixels != 0) {
        getListPetRequiredInShop();
      }
    }
  }

  Future<void> getListPetActiveInShop() async {
    if (loadingActive) {
      return;
    }

    loadingActive = true;
    final res = await ShopApi().searchPetsActiveInShop(
        widget.shopId, widget.title, 10, currentPageActive * 10);

    if (res['isSuccess'] == false) {
      setState(() {
        loadingActive = false;
      });
      return;
    }

    final List<PetInCard> pets = res['data'];

    setState(() {
      listPetActiveInCards.addAll(pets);
      if (selectedSpecieFilters.isEmpty && selectedAgeFilters.isEmpty) {
        listPetActiveFilter.addAll(pets);
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
                  selectedAgeFilters.contains(petAgeItem.name))) {
            return true;
          }
          return false;
        }).toList();
        listPetActiveFilter.addAll(addFilterList);
      }

      currentPageActive++;
      loadingActive = false;
    });
  }

  Future<void> getListPetRequiredInShop() async {
    if (loadingRequest) {
      return;
    }

    loadingRequest = true;
    final res = await ShopApi().searchPetsRequestInShop(
        widget.shopId, widget.title, 10, currentPageRequest * 10);

    if (res['isSuccess'] == false) {
      setState(() {
        loadingRequest = false;
      });
      return;
    }

    final List<PetInCard> pets = res['data'];

    setState(() {
      listPetRequestInCards.addAll(pets);
      if (selectedSpecieFilters.isEmpty && selectedAgeFilters.isEmpty) {
        listPetRequestFilter.addAll(pets);
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
                  selectedAgeFilters.contains(petAgeItem.name))) {
            return true;
          }
          return false;
        }).toList();
        listPetRequestFilter.addAll(addFilterList);
      }

      currentPageRequest++;
      loadingRequest = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                colors: [
                  gradientStartColor,
                  gradientMidColor,
                  gradientEndColor
                ],
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: buttonBackgroundColor,
                labelColor: buttonBackgroundColor,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(
                    text: 'Thú cưng của bạn',
                  ),
                  Tab(
                    text: 'Đang yêu cầu',
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.filter_alt,
                  color: iconButtonColor, size: 30),
              onPressed: () {
                scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            loadingActive
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(buttonBackgroundColor),
                    ),
                  )
                : listPetActiveFilter.isEmpty
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
                        controller: _scrollActiveController,
                        itemCount: listPetActiveFilter.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PetInforScreen(
                                  idPet: listPetActiveInCards[index].idPet,
                                  ageID: listPetActiveInCards[index].ageID,
                                ),
                              ));
                            },
                            child: PetActiveOfShopWidget(
                                petInCard: listPetActiveInCards[index],
                                onRemove: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Xác nhận"),
                                        content: const Text(
                                            "Bạn có chắc chắn muốn xóa thú cưng khỏi cửa hàng không?"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Không",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 84, 84, 84))),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              var res = await ShopApi()
                                                  .deletePet(
                                                      listPetActiveInCards[
                                                              index]
                                                          .idPet);
                                              if (res['isSuccess']) {
                                                showTopSnackBar(
                                                  // ignore: use_build_context_synchronously
                                                  Overlay.of(context),
                                                  const CustomSnackBar.success(
                                                    message:
                                                        'Xóa Thú cưng thành công!',
                                                  ),
                                                  displayDuration:
                                                      const Duration(
                                                          seconds: 0),
                                                );
                                                setState(() {
                                                  listPetActiveFilter
                                                      .removeAt(index);
                                                });
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();
                                              } else {
                                                showTopSnackBar(
                                                  // ignore: use_build_context_synchronously
                                                  Overlay.of(context),
                                                  const CustomSnackBar.error(
                                                    message:
                                                        'Đã xảy ra lỗi, vui lòng thử lại sau!',
                                                  ),
                                                  displayDuration:
                                                      const Duration(
                                                          seconds: 0),
                                                );
                                              }
                                            },
                                            child: const Text("Xóa",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 209, 87, 78))),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                onEdit: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => UpdatePetScreen(
                                      idPet: listPetActiveInCards[index].idPet,
                                    ),
                                  ))
                                      .then((value) {
                                    listPetActiveInCards.clear();
                                    listPetActiveFilter.clear();

                                    currentPageActive = 0;
                                    getListPetActiveInShop();

                                    selectedSpecieFilters.clear();
                                    selectedAgeFilters.clear();
                                  });
                                }),
                          );
                        },
                      ),
            loadingRequest
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(buttonBackgroundColor),
                    ),
                  )
                : listPetRequestFilter.isEmpty
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
                        controller: _scrollRequestController,
                        itemCount: listPetRequestFilter.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PetInforScreen(
                                  idPet: listPetRequestInCards[index].idPet,
                                  ageID: listPetRequestInCards[index].ageID,
                                ),
                              ));
                            },
                            child: PetRequestOfShopWidget(
                                petInCard: listPetRequestInCards[index],
                                onRemove: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Xác nhận"),
                                        content: const Text(
                                            "Bạn có chắc chắn muốn xóa thú cưng khỏi cửa hàng không?"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Không",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 84, 84, 84))),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              var res = await ShopApi()
                                                  .deletePet(
                                                      listPetRequestInCards[
                                                              index]
                                                          .idPet);
                                              if (res['isSuccess']) {
                                                showTopSnackBar(
                                                  // ignore: use_build_context_synchronously
                                                  Overlay.of(context),
                                                  const CustomSnackBar.success(
                                                    message:
                                                        'Xóa Thú cưng thành công!',
                                                  ),
                                                  displayDuration:
                                                      const Duration(
                                                          seconds: 0),
                                                );
                                                setState(() {
                                                  listPetRequestFilter
                                                      .removeAt(index);
                                                });
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();
                                              } else {
                                                showTopSnackBar(
                                                  // ignore: use_build_context_synchronously
                                                  Overlay.of(context),
                                                  const CustomSnackBar.error(
                                                    message:
                                                        'Đã xảy ra lỗi, vui lòng thử lại sau!',
                                                  ),
                                                  displayDuration:
                                                      const Duration(
                                                          seconds: 0),
                                                );
                                              }
                                            },
                                            child: const Text("Xóa",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 209, 87, 78))),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }),
                          );
                        },
                      ),
          ],
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
                                  final isSelected = selectedSpecieFilters
                                      .contains(filterItem);
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
                                      final isSelected = selectedAgeFilters
                                          .contains(filterItem);
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (isSelected) {
                                              selectedAgeFilters
                                                  .remove(filterItem);
                                            } else {
                                              selectedAgeFilters
                                                  .add(filterItem);
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
                              listPetActiveFilter =
                                  listPetActiveInCards.where((pet) {
                                if (selectedSpecieFilters.isEmpty &&
                                    selectedAgeFilters.isEmpty) {
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
                                            .contains(petAgeItem.name))) {
                                  return true;
                                }
                                return false;
                              }).toList();

                              listPetRequestFilter =
                                  listPetRequestInCards.where((pet) {
                                if (selectedSpecieFilters.isEmpty &&
                                    selectedAgeFilters.isEmpty) {
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
                                            .contains(petAgeItem.name))) {
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
      ),
    );
  }
}
