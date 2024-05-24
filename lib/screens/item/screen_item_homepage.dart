import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pethome_mobileapp/model/item/model_item_in_card.dart';
import 'package:pethome_mobileapp/model/item/model_item_type.dart';
import 'package:pethome_mobileapp/screens/item/screen_item_detail.dart';
import 'package:pethome_mobileapp/screens/item/screen_item_search_filter.dart';
import 'package:pethome_mobileapp/services/api/item_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/item/item_card.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ItemHomeScreen extends StatefulWidget {
  final Function(bool) updateBottomBarVisibility;
  const ItemHomeScreen({super.key, required this.updateBottomBarVisibility});

  @override
  // ignore: library_private_types_in_public_api
  _ItemHomeScreenState createState() => _ItemHomeScreenState();
}

class _ItemHomeScreenState extends State<ItemHomeScreen>
    with SingleTickerProviderStateMixin {
  List<ItemInCard> listItemsInCards = List.empty(growable: true);
  List<ItemType> listItemTypes = List.empty(growable: true);

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isBottomBarVisible = true;

  int currentPage = 0;
  bool loading = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _scrollController.addListener(_listenerScroll);

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    getListItemsInCards();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
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

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      if (_tabController.index == 1) {
        getListItemType();
      } else if (_tabController.index == 2) {}
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

    if (mounted) {
      setState(() {
        listItemsInCards.addAll(items);
        currentPage++;
        loading = false;
      });
    }
  }

  Future<void> getListItemType() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<ItemType> itemTypes = await ItemApi().getItemTypes();

    if (itemTypes.isEmpty) {
      loading = false;
      return;
    }

    if (mounted) {
      setState(() {
        listItemTypes = itemTypes;
        loading = false;
      });
    }
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
                        ItemSearchAndFilterScreen(title: searchKey),
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
                  Tab(text: 'Tất cả'),
                  Tab(text: 'Danh mục hàng'),
                  Tab(text: 'Giảm giá'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: buttonBackgroundColor,
                    ),
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    controller: _scrollController,
                    itemCount: listItemsInCards.length,
                    itemBuilder: (context, index) {
                      if (index < listItemsInCards.length) {
                        if (index % 2 == 0 &&
                            index < listItemsInCards.length - 1) {
                          return Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ItemDetailScreen(
                                        idItem: listItemsInCards[index].idItem,
                                        showCartIcon: true,
                                      ),
                                    ));
                                  },
                                  child: ItemCard(
                                      itemInCard: listItemsInCards[index]),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ItemDetailScreen(
                                        idItem:
                                            listItemsInCards[index + 1].idItem,
                                        showCartIcon: true,
                                      ),
                                    ));
                                  },
                                  child: ItemCard(
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
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ItemDetailScreen(
                                          idItem:
                                              listItemsInCards[index].idItem,
                                          showCartIcon: true),
                                    ));
                                  },
                                  child: ItemCard(
                                      itemInCard: listItemsInCards[index]),
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

            loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: buttonBackgroundColor,
                    ),
                  )
                : ListView.builder(
                    itemCount: listItemTypes.length,
                    itemBuilder: (context, index) {
                      final itemType = listItemTypes[index];
                      return ExpansionTile(
                        iconColor: buttonBackgroundColor,
                        title: Row(
                          children: [
                            Image.network(
                              itemType.picture,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                itemType.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: buttonBackgroundColor,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        children: itemType.itemTypeDetail.map((detail) {
                          return ListTile(
                            title: Text('${detail.name}. (${detail.count})', style: const TextStyle(
                              fontSize: 15,
                            )),
                            onTap: () {
                              // Handle tap on itemTypeDetail
                              print('Tapped on: ${detail.name}');
                            },
                          );
                        }).toList(),
                      );
                    },
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
