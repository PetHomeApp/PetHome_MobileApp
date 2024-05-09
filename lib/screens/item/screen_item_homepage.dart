import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pethome_mobileapp/model/item/model_item_in_card.dart';
import 'package:pethome_mobileapp/screens/item/screen_item_detail.dart';
import 'package:pethome_mobileapp/screens/pet/screen_pet_seach_filter.dart';
import 'package:pethome_mobileapp/services/api/item_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/item/item_card.dart';

class ItemHomeScreen extends StatefulWidget {
  final Function(bool) updateBottomBarVisibility;
  const ItemHomeScreen({super.key, required this.updateBottomBarVisibility});

  @override
  // ignore: library_private_types_in_public_api
  _ItemHomeScreenState createState() => _ItemHomeScreenState();
}

class _ItemHomeScreenState extends State<ItemHomeScreen> {
  List<ItemInCard> listItemsInCards = List.empty(growable: true);

  final ScrollController _scrollController = ScrollController();
  bool _isBottomBarVisible = true;

  int currentPage = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _scrollController.addListener(_listenerScroll);

    getListItemsInCards();
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
        getListItemsInCards();
      }
    }
  }

  Future<void> getListItemsInCards() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<ItemInCard> items =
        await ItemApi().getItemsInCard(10, currentPage * 10);

    if (items.isEmpty) {
      loading = false;
      return;
    }

    setState(() {
      listItemsInCards.addAll(items);
      currentPage++;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PetSearchAndFilterScreen(
                      title: 'a',
                    ),
                  ));
                },
                icon: const Icon(
                  Icons.search,
                  size: 30,
                  color: buttonBackgroundColor,
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              color: Colors.white,
              child: const TabBar(
                indicatorColor: buttonBackgroundColor,
                labelColor: buttonBackgroundColor,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: 'Tất cả'),
                  Tab(text: 'Danh mục hàng'),
                  Tab(text: 'Giảm giá'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              controller: _scrollController,
              itemCount: listItemsInCards.length,
              itemBuilder: (context, index) {
                if (index < listItemsInCards.length) {
                  if (index % 2 == 0 && index < listItemsInCards.length - 1) {
                    return Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ItemDetailScreen(
                                  idItem: listItemsInCards[index].idItem,
                                ),
                              ));
                            },
                            child:
                                ItemCart(itemInCard: listItemsInCards[index]),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ItemDetailScreen(
                                  idItem: listItemsInCards[index + 1].idItem,
                                ),
                              ));
                            },
                            child: ItemCart(
                                itemInCard: listItemsInCards[index + 1]),
                          ),
                        ),
                      ],
                    );
                  } else if (index % 2 == 0 &&
                      index == listItemsInCards.length - 1) {
                    return Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ItemDetailScreen(
                                    idItem: listItemsInCards[index].idItem),
                              ));
                            },
                            child:
                                ItemCart(itemInCard: listItemsInCards[index]),
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

            // Tab 2
            const Center(
              child: Text('Tab 2'),
            ),

            // Tab 3
            const Center(
              child: Text('Tab 3'),
            ),
          ],
        ),
      ),
    );
  }
}
