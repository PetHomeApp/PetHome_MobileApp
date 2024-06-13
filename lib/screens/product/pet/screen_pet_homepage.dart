import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_in_card.dart';
import 'package:pethome_mobileapp/screens/product/pet/screen_pet_detail.dart';
import 'package:pethome_mobileapp/screens/product/pet/screen_pet_search_filter.dart';
import 'package:pethome_mobileapp/services/api/pet_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/product/pet/pet_card.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PetHomeScreen extends StatefulWidget {
  final Function(bool) updateBottomBarVisibility;
  const PetHomeScreen({super.key, required this.updateBottomBarVisibility});

  @override
  // ignore: library_private_types_in_public_api
  _PetHomeScreenState createState() => _PetHomeScreenState();
}

class _PetHomeScreenState extends State<PetHomeScreen> {
  List<PetInCard> listPetInCards = List.empty(growable: true);

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isBottomBarVisible = true;

  int currentPage = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _scrollController.addListener(_listenerScroll);

    getListPetInCards();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isBottomBarVisible) {
        setState(() {
          _isBottomBarVisible = false;
          widget.updateBottomBarVisibility(false);
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isBottomBarVisible) {
        setState(() {
          _isBottomBarVisible = true;
          widget.updateBottomBarVisibility(true);
        });
      }
    }
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
        await PetApi().getPetsInCard(10, currentPage * 10);

    if (pets.isEmpty) {
      loading = false;
      return;
    }

    setState(() {
      listPetInCards.addAll(pets);
      currentPage++;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: TextField(
                    controller: _searchController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: 'Nhập để tìm kiếm...',
                      border: InputBorder.none,
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                String searchKey = _searchController.text;
                if (searchKey.isEmpty) {
                  showTopSnackBar(
                    // ignore: use_build_context_synchronously
                    Overlay.of(context),
                    const CustomSnackBar.error(
                      message: 'Vui lòng nhập thông tin tìm kiếm!',
                    ),
                    displayDuration: const Duration(seconds: 0),
                  );
                  return;
                }
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PetSearchAndFilterScreen(title: searchKey),
                ));
                _searchController.clear();
              },
              icon: const Icon(
                Icons.search,
                size: 30,
                color: iconButtonColor,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [gradientStartColor, gradientEndColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: appColor),
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              controller: _scrollController,
              itemCount: listPetInCards.length,
              itemBuilder: (context, index) {
                if (index < listPetInCards.length) {
                  if (index % 2 == 0 && index < listPetInCards.length - 1) {
                    return Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PetDetailScreen(
                                  idPet: listPetInCards[index].idPet,
                                  showCartIcon: true,
                                ),
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 4.0, top: 4.0, bottom: 4.0),
                              child: PetCard(petInCard: listPetInCards[index]),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PetDetailScreen(
                                  idPet: listPetInCards[index + 1].idPet,
                                  showCartIcon: true,
                                ),
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 4.0, right: 8.0, top: 4.0, bottom: 4.0),
                              child:
                                  PetCard(petInCard: listPetInCards[index + 1]),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (index % 2 == 0 &&
                      index == listPetInCards.length - 1) {
                    return Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PetDetailScreen(
                                  idPet: listPetInCards[index].idPet,
                                  showCartIcon: true,
                                ),
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 4.0, top: 4.0, bottom: 4.0),
                              child: PetCard(petInCard: listPetInCards[index]),
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
                } else {
                  Timer(const Duration(milliseconds: 30), () {
                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );
                  });
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor),
                    ),
                  );
                }
              },
            ),
    );
  }
}
