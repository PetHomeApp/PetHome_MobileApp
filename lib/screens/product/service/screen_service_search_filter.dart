import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_in_card.dart';
import 'package:pethome_mobileapp/screens/product/service/screen_service_detail.dart';
import 'package:pethome_mobileapp/services/api/product/service_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/setting/list_area.dart';
import 'package:pethome_mobileapp/widgets/product/service/service_shop_card.dart';

class ServiceSearchAndFilterScreen extends StatefulWidget {
  const ServiceSearchAndFilterScreen(
      {super.key, required this.title, required this.serviceTypeId});
  final int serviceTypeId;
  final String title;

  @override
  State<ServiceSearchAndFilterScreen> createState() =>
      _ServiceSearchAndFilterScreenState();
}

class _ServiceSearchAndFilterScreenState
    extends State<ServiceSearchAndFilterScreen> {
  List<ServiceInCard> listServiceInCard = List.empty(growable: true);
  List<ServiceInCard> listServiceFiltered = List.empty(growable: true);

  List<String> filterArea = area;
  Set<String> selectedAreaFilters = {};

  List<String> filterRate = ['Không', 'Tăng dần', 'Giảm dần'];
  String selectedRateSort = 'Không';
  Set<String> selectedRateFilters = {};

  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool showAll = false;
  bool loading = false;

  int currentPage = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listenerScroll);
    selectedRateFilters.add(filterRate[0]);
    getListService('NONE');
  }

  void _listenerScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        String sortRating = selectedRateSort == 'Tăng dần'
            ? 'ASC'
            : selectedRateSort == 'Giảm dần'
                ? 'DESC'
                : 'NONE';
        getListService(sortRating);
      }
    }
  }

  Future<void> getListService(String sortRating) async {
    if (loading) {
      return;
    }

    loading = true;
    final List<ServiceInCard> listService = await ServiceApi()
        .searchServicesInCard(widget.serviceTypeId, widget.title, 40,
            currentPage * 40, sortRating);

    if (listService.isEmpty) {
      setState(() {
        loading = false;
      });
      return;
    }

    setState(() {
      listServiceInCard.addAll(listService);
      if (selectedAreaFilters.isEmpty) {
        listServiceFiltered.addAll(listService);
      } else {
        List<ServiceInCard> addFilterList = List.empty(growable: true);
        addFilterList = listService.where((service) {
          if (selectedAreaFilters.isEmpty ||
              selectedAreaFilters
                  .any((element) => service.areas.contains(element))) {
            return true;
          }
          return false;
        }).toList();
        listServiceFiltered.addAll(addFilterList);
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
          : listServiceFiltered.isEmpty
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
                  itemCount: listServiceFiltered.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ServiceDetailScreen(
                              idService: listServiceInCard[index].idService),
                        ));
                      },
                      child: ServiceShopCard(
                          serviceInCard: listServiceFiltered[index]),
                    );
                  }),
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
                        const Text('Đánh giá: ',
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
                                  children: filterRate.map((filterRate) {
                                    final isSelected =
                                        selectedRateSort == filterRate;
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedRateSort = filterRate;
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
                                          filterRate,
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
                            selectedRateSort = 'Không';
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
                            if (selectedRateFilters.first != selectedRateSort) {
                              selectedRateFilters.clear();
                              selectedRateFilters.add(selectedRateSort);

                              listServiceFiltered.clear();
                              listServiceInCard.clear();
                              currentPage = 0;
                              selectedRateFilters.clear();
                              selectedRateFilters.add(selectedRateSort);
                              getListService(selectedRateSort == 'Tăng dần'
                                  ? 'ASC'
                                  : selectedRateSort == 'Giảm dần'
                                      ? 'DESC'
                                      : 'NONE');
                            } else {
                              listServiceFiltered =
                                  listServiceInCard.where((item) {
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
                            }

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
