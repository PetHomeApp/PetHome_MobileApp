import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/item/model_item_in_card.dart';
import 'package:pethome_mobileapp/screens/item/screen_item_detail.dart';
import 'package:pethome_mobileapp/services/api/item_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/setting/list_area.dart';
import 'package:pethome_mobileapp/widgets/item/item_card.dart';

class ItemSearchAndFilterScreen extends StatefulWidget {
  const ItemSearchAndFilterScreen(
      {super.key,
      required this.title,
      required this.searchType,
      required this.detailTypeID});
  final String title;
  final String searchType;
  final int detailTypeID;

  @override
  State<ItemSearchAndFilterScreen> createState() =>
      _ItemSearchAndFilterScreenState();
}

class _ItemSearchAndFilterScreenState extends State<ItemSearchAndFilterScreen> {
  List<ItemInCard> listItemsInCard = List.empty(growable: true);
  List<ItemInCard> listItemsFilter = List.empty(growable: true);

  List<String> filterArea = area;
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
    if (widget.searchType == 'search') {
      getListItemsBySearchInCards();
    } else {
      getListItemsByCategoryInCards();
    }
  }

  void _listenerScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        if (widget.searchType == 'search') {
          getListItemsBySearchInCards();
        } else {
          getListItemsByCategoryInCards();
        }
      }
    }
  }

  Future<void> getListItemsBySearchInCards() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<ItemInCard> items =
        await ItemApi().searchItemsInCard(widget.title, 10, currentPage * 10);

    if (items.isEmpty) {
      loading = false;
      return;
    }

    setState(() {
      listItemsInCard.addAll(items);
      if (selectedAreaFilters.isEmpty) {
        listItemsFilter.addAll(items);
      } else {
        List<ItemInCard> addFilterList = List.empty(growable: true);
        addFilterList = items.where((item) {
          if ((selectedAreaFilters.isEmpty ||
              selectedAreaFilters
                  .any((element) => item.areas.contains(element)))) {
            return true;
          }
          return false;
        }).toList();
        listItemsFilter.addAll(addFilterList);
      }

      currentPage++;
      loading = false;
    });
  }

  Future<void> getListItemsByCategoryInCards() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<ItemInCard> items = await ItemApi()
        .getItemsByTypeInCard(widget.detailTypeID, 10, currentPage * 10);

    if (items.isEmpty) {
      loading = false;
      return;
    }

    setState(() {
      listItemsInCard.addAll(items);
      if (selectedAreaFilters.isEmpty) {
        listItemsFilter.addAll(items);
      } else {
        List<ItemInCard> addFilterList = List.empty(growable: true);
        addFilterList = items.where((item) {
          if ((selectedAreaFilters.isEmpty ||
              selectedAreaFilters
                  .any((element) => item.areas.contains(element)))) {
            return true;
          }
          return false;
        }).toList();
        listItemsFilter.addAll(addFilterList);
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
          : listItemsFilter.isEmpty
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
                  itemCount: listItemsFilter.length,
                  itemBuilder: (context, index) {
                    if (index % 2 == 0 && index < listItemsFilter.length - 1) {
                      return Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ItemDetailScreen(
                                    idItem: listItemsFilter[index].idItem,
                                    showCartIcon: true,
                                  ),
                                ));
                              },
                              child:
                                  ItemCard(itemInCard: listItemsFilter[index]),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ItemDetailScreen(
                                    idItem: listItemsFilter[index + 1].idItem,
                                    showCartIcon: true,
                                  ),
                                ));
                              },
                              child: ItemCard(
                                  itemInCard: listItemsFilter[index + 1]),
                            ),
                          ),
                        ],
                      );
                    } else if (index % 2 == 0 &&
                        index == listItemsFilter.length - 1) {
                      return Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ItemDetailScreen(
                                    idItem: listItemsFilter[index].idItem,
                                    showCartIcon: true,
                                  ),
                                ));
                              },
                              child:
                                  ItemCard(itemInCard: listItemsFilter[index]),
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
                            selectedAreaFilters.clear();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
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
                          setState(() {
                            listItemsFilter = listItemsInCard.where((item) {
                              if (selectedAreaFilters.isEmpty) {
                                return true;
                              }

                              if (selectedAreaFilters.isEmpty ||
                                  selectedAreaFilters.any((element) =>
                                      item.areas.contains(element))) {
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
