import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_in_card.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_type.dart';
import 'package:pethome_mobileapp/screens/my/screen_notification.dart';
import 'package:pethome_mobileapp/screens/product/item/screen_item_detail.dart';
import 'package:pethome_mobileapp/screens/product/item/screen_item_search_filter.dart';
import 'package:pethome_mobileapp/services/api/product/item_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/product/item/item_card.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ItemHomeScreen extends StatefulWidget {
  final ValueNotifier<int> counterNotifier;
  final Function(bool) updateBottomBarVisibility;
  const ItemHomeScreen(
      {super.key,
      required this.counterNotifier,
      required this.updateBottomBarVisibility});

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

  int countNotification = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _scrollController.addListener(_listenerScroll);

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    getListItemsInCards();
    countNotification = widget.counterNotifier.value;
    widget.counterNotifier.addListener(_updateCounter);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    widget.counterNotifier.removeListener(_updateCounter);
    super.dispose();
  }

  void _updateCounter() {
    setState(() {
      countNotification = widget.counterNotifier.value;
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
        await ItemApi().getItemsInCard(40, currentPage * 40);

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
                    builder: (context) => ItemSearchAndFilterScreen(
                        title: searchKey,
                        searchType: 'search',
                        detailTypeID: 0),
                  ));
                  _searchController.clear();
                },
                icon: const Icon(
                  Icons.search,
                  size: 30,
                  color: iconButtonColor,
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
            preferredSize: const Size.fromHeight(48.0),
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 4, top: 4, bottom: 4),
                                    child: ItemCard(
                                        itemInCard: listItemsInCards[index]),
                                  ),
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, right: 8, top: 4, bottom: 4),
                                    child: ItemCard(
                                        itemInCard:
                                            listItemsInCards[index + 1]),
                                  ),
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 4, top: 4, bottom: 4),
                                    child: ItemCard(
                                        itemInCard: listItemsInCards[index]),
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
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                itemType.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: buttonBackgroundColor,
                                  fontSize: 18,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        children: itemType.itemTypeDetail.map((detail) {
                          return ListTile(
                            title: Text('${detail.name}  -  (${detail.count})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                )),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ItemSearchAndFilterScreen(
                                  title: detail.name,
                                  searchType: 'type',
                                  detailTypeID: detail.idItemTypeDetail,
                                ),
                              ));
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
