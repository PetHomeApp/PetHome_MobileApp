import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_in_card.dart';
import 'package:pethome_mobileapp/screens/shop/managershop/manager/screen_add_pet.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/pet_of_shop.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ManagerPetScreen extends StatefulWidget {
  final Function(bool) updateBottomBarVisibility;
  final String shopId;
  const ManagerPetScreen(
      {super.key,
      required this.updateBottomBarVisibility,
      required this.shopId});

  @override
  State<ManagerPetScreen> createState() => _ManagerPetScreenState();
}

class _ManagerPetScreenState extends State<ManagerPetScreen> {
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

    getListPetInShop();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _listenerScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        getListPetInShop();
      }
    }
  }

  Future<void> getListPetInShop() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<PetInCard> pets =
        await ShopApi().getListPetInShop(widget.shopId, 10, currentPage * 10);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
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
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Nhập để tìm kiếm...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                style: const TextStyle(color: Colors.white),
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
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) =>
                //       PetSearchAndFilterScreen(title: searchKey),
                // ));
                _searchController.clear();
              },
              icon: const Icon(
                Icons.search,
                size: 30,
                color: iconButtonColor,
              ),
            ),
            // Insert icon button
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      const AddPetScreen(),
                ));
                getListPetInShop();
              },
              icon: const Icon(
                Icons.add,
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
      body: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        controller: _scrollController,
        itemCount: listPetInCards.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 16),
        itemBuilder: (context, index) {
          return PetOfShopWidget(
              petInCard: listPetInCards[index],
              onRemove: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Xác nhận"),
                      content: const Text(
                          "Bạn có chắc chắn muốn xóa thú cưng khỏi giỏ hàng không?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Không",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 84, 84, 84))),
                        ),
                        TextButton(
                          onPressed: () async {},
                          child: const Text("Xóa",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 209, 87, 78))),
                        ),
                      ],
                    );
                  },
                );
              },
              onEdit: () {});
        },
      ),
    );
  }
}
