import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_in_card.dart';
import 'package:pethome_mobileapp/screens/shop/managershop/manager/item/screen_item_infor.dart';
import 'package:pethome_mobileapp/screens/shop/managershop/manager/item/screen_update_item.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/product/item/item_active_of_shop.dart';
import 'package:pethome_mobileapp/widgets/shop/product/item/item_request_of_shop.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SearchShopItemScreen extends StatefulWidget {
  const SearchShopItemScreen(
      {super.key, required this.shopId, required this.title});

  final String shopId;
  final String title;

  @override
  State<SearchShopItemScreen> createState() => _SearchShopItemScreenState();
}

class _SearchShopItemScreenState extends State<SearchShopItemScreen>
    with SingleTickerProviderStateMixin {
  List<ItemInCard> listItemsActiveInCard = List.empty(growable: true);
  List<ItemInCard> listItemsRequestInCard = List.empty(growable: true);

  final ScrollController _scrollActiveController = ScrollController();
  final ScrollController _scrollRequestController = ScrollController();

  int currentPageActive = 0;
  int currentPageRequest = 0;

  int countActive = 0;
  int countRequest = 0;

  bool loadingActive = false;
  bool loadingRequest = false;

  late TabController _tabController;

  @override
  void initState() {
    _scrollActiveController.addListener(_listenerScrollActive);
    _scrollRequestController.addListener(_listenerScrollRequest);

    getListItemActiveInShop();
    getListItemRequiredInShop();

    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _scrollActiveController.dispose();
    _scrollRequestController.dispose();

    _tabController.dispose();
    super.dispose();
  }

  void _listenerScrollActive() {
    if (_scrollActiveController.position.atEdge) {
      if (_scrollActiveController.position.pixels != 0) {
        getListItemActiveInShop();
      }
    }
  }

  void _listenerScrollRequest() {
    if (_scrollRequestController.position.atEdge) {
      if (_scrollRequestController.position.pixels != 0) {
        getListItemRequiredInShop();
      }
    }
  }

  Future<void> getListItemActiveInShop() async {
    if (loadingActive) {
      return;
    }

    loadingActive = true;
    final res = await ShopApi().searchItemsActiveInShop(
        widget.shopId, widget.title, 10, currentPageActive * 10);

    if (res['isSuccess'] == false) {
      setState(() {
        loadingActive = false;
      });
      return;
    }

    countActive = res['count'];
    final List<ItemInCard> items = res['data'];

    setState(() {
      listItemsActiveInCard.addAll(items);
      currentPageActive++;
      loadingActive = false;
    });
  }

  Future<void> getListItemRequiredInShop() async {
    if (loadingRequest) {
      return;
    }

    setState(() {
      loadingRequest = true;
    });

    loadingRequest = true;
    final res = await ShopApi().searchItemsRequestInShop(
        widget.shopId, widget.title, 10, currentPageRequest * 10);

    if (res['isSuccess'] == false) {
      setState(() {
        loadingRequest = false;
      });
      return;
    }

    countRequest = res['count'];
    final List<ItemInCard> items = res['data'];

    setState(() {
      listItemsRequestInCard.addAll(items);
      currentPageRequest++;
      loadingRequest = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          title: Text(
            widget.title,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
                tabs: [
                  Tab(
                    text: 'Vật phẩm của bạn ($countActive)',
                  ),
                  Tab(
                    text: 'Đang yêu cầu ($countRequest)',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            loadingActive
                ? const Center(
                    child: CircularProgressIndicator(
                      color: buttonBackgroundColor,
                    ),
                  )
                : listItemsActiveInCard.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage(
                                  'lib/assets/pictures/icon_no_service.png'),
                              width: 70,
                              height: 70,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Cửa hàng của bạn chưa có Vật phẩm nào!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: buttonBackgroundColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        controller: _scrollActiveController,
                        itemCount: listItemsActiveInCard.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 16),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ItemInforScreen(
                                  idItem: listItemsActiveInCard[index].idItem,
                                ),
                              ));
                            },
                            child: ItemActiveOfShopWidget(
                                itemInCard: listItemsActiveInCard[index],
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
                                                  .deleteItem(
                                                      listItemsActiveInCard[
                                                              index]
                                                          .idItem);
                                              if (res['isSuccess']) {
                                                showTopSnackBar(
                                                  // ignore: use_build_context_synchronously
                                                  Overlay.of(context),
                                                  const CustomSnackBar.success(
                                                    message:
                                                        'Xóa Vật phẩm thành công!',
                                                  ),
                                                  displayDuration:
                                                      const Duration(
                                                          seconds: 0),
                                                );
                                                setState(() {
                                                  listItemsActiveInCard
                                                      .removeAt(index);
                                                  countActive--;
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
                                    builder: (context) => UpdateItemScreen(
                                      idItem:
                                          listItemsActiveInCard[index].idItem,
                                    ),
                                  ))
                                      .then((value) {
                                    listItemsActiveInCard.clear();
                                    countActive = 0;
                                    currentPageActive = 0;
                                    getListItemActiveInShop();
                                  });
                                }),
                          );
                        },
                      ),
            loadingRequest
                ? const Center(
                    child: CircularProgressIndicator(
                      color: buttonBackgroundColor,
                    ),
                  )
                : listItemsRequestInCard.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage(
                                  'lib/assets/pictures/icon_no_service.png'),
                              width: 70,
                              height: 70,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Bạn chưa gửi yêu cầu Vật phẩm nào!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: buttonBackgroundColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        controller: _scrollRequestController,
                        itemCount: listItemsRequestInCard.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 16),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ItemInforScreen(
                                  idItem: listItemsRequestInCard[index].idItem,
                                ),
                              ));
                            },
                            child: ItemRequestOfShopWidget(
                                itemInCard: listItemsRequestInCard[index],
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
                                                  .deleteItem(
                                                      listItemsRequestInCard[
                                                              index]
                                                          .idItem);
                                              if (res['isSuccess']) {
                                                showTopSnackBar(
                                                  // ignore: use_build_context_synchronously
                                                  Overlay.of(context),
                                                  const CustomSnackBar.success(
                                                    message:
                                                        'Xóa Vật phẩm thành công!',
                                                  ),
                                                  displayDuration:
                                                      const Duration(
                                                          seconds: 0),
                                                );
                                                setState(() {
                                                  listItemsRequestInCard
                                                      .removeAt(index);
                                                  countRequest--;
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
      ),
    );
  }
}
