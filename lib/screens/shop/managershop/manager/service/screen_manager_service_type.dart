import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_in_card.dart';
import 'package:pethome_mobileapp/screens/shop/managershop/manager/service/screen_service_infor.dart';
import 'package:pethome_mobileapp/screens/shop/managershop/manager/service/screen_update_service.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/product/service/service_active_of_shop.dart';
import 'package:pethome_mobileapp/widgets/shop/product/service/service_request_of_shop.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ManagerServiceByTypeScreen extends StatefulWidget {
  final String shopId;
  final String title;
  final int serviceTypeDetailId;

  const ManagerServiceByTypeScreen(
      {super.key,
      required this.shopId,
      required this.serviceTypeDetailId,
      required this.title});

  @override
  State<ManagerServiceByTypeScreen> createState() =>
      _ManagerServiceByTypeScreenState();
}

class _ManagerServiceByTypeScreenState extends State<ManagerServiceByTypeScreen>
    with SingleTickerProviderStateMixin {
  List<ServiceInCard> servicesActive = List.empty(growable: true);
  List<ServiceInCard> servicesRequest = List.empty(growable: true);

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
    super.initState();
    _scrollActiveController.addListener(_listenerScrollActive);

    _scrollRequestController.addListener(_listenerScrollRequest);

    _tabController = TabController(length: 2, vsync: this);

    getListServiceActiveInShop();
    getListServiceRequiredInShop();
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
        getListServiceActiveInShop();
      }
    }
  }

  void _listenerScrollRequest() {
    if (_scrollRequestController.position.atEdge) {
      if (_scrollRequestController.position.pixels != 0) {
        getListServiceRequiredInShop();
      }
    }
  }

  Future<void> getListServiceActiveInShop() async {
    if (loadingActive) {
      return;
    }

    loadingActive = true;
    final res = await ShopApi().getListServiceActiveInShop(
        widget.serviceTypeDetailId, widget.shopId, 10, currentPageActive * 10);

    if (res['isSuccess'] == false) {
      setState(() {
        loadingActive = false;
      });
      return;
    }

    countActive = res['count'];
    final List<ServiceInCard> services = res['data'];

    setState(() {
      servicesActive.addAll(services);
      currentPageActive++;
      loadingActive = false;
    });
  }

  Future<void> getListServiceRequiredInShop() async {
    if (loadingRequest) {
      return;
    }

    setState(() {
      loadingRequest = true;
    });

    loadingRequest = true;
    final res = await ShopApi().getListServiceRequestInShop(
        widget.serviceTypeDetailId, widget.shopId, 10, currentPageRequest * 10);

    if (res['isSuccess'] == false) {
      setState(() {
        loadingRequest = false;
      });
      return;
    }

    countRequest = res['count'];
    final List<ServiceInCard> services = res['data'];

    setState(() {
      servicesRequest.addAll(services);
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
                    text: 'Dịch vụ của bạn ($countActive)',
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
                : servicesActive.isEmpty
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
                              'Cửa hàng của bạn chưa có Dịch vụ nào!',
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
                        itemCount: servicesActive.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 16),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ServiceInforScreen(
                                  idService: servicesActive[index].idService,
                                ),
                              ));
                            },
                            child: ServiceActiveOfShopWidget(
                                serviceInCard: servicesActive[index],
                                onRemove: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Xác nhận"),
                                        content: const Text(
                                            "Bạn có chắc chắn muốn xóa dịch vụ khỏi cửa hàng không?"),
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
                                                  .deleteService(
                                                      servicesActive[index]
                                                          .idService);
                                              if (res['isSuccess']) {
                                                showTopSnackBar(
                                                  // ignore: use_build_context_synchronously
                                                  Overlay.of(context),
                                                  const CustomSnackBar.success(
                                                    message:
                                                        'Xóa Dịch vụ thành công!',
                                                  ),
                                                  displayDuration:
                                                      const Duration(
                                                          seconds: 0),
                                                );
                                                setState(() {
                                                  servicesActive
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
                                    builder: (context) => UpdateServiceScreen(
                                      idService:
                                          servicesActive[index].idService,
                                    ),
                                  ))
                                      .then((value) {
                                    servicesActive.clear();
                                    currentPageActive = 0;
                                    getListServiceActiveInShop();
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
                : servicesRequest.isEmpty
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
                              'Bạn chưa gửi yêu cầu Dịch vụ nào!',
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
                        itemCount: servicesRequest.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 16),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ServiceInforScreen(
                                  idService: servicesRequest[index].idService,
                                ),
                              ));
                            },
                            child: ServiceRequestOfShopWidget(
                              serviceInCard: servicesRequest[index],
                              onRemove: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Xác nhận"),
                                      content: const Text(
                                          "Bạn có chắc chắn muốn xóa dịch vụ khỏi cửa hàng không?"),
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
                                                .deleteService(
                                                    servicesRequest[index]
                                                        .idService);
                                            if (res['isSuccess']) {
                                              showTopSnackBar(
                                                // ignore: use_build_context_synchronously
                                                Overlay.of(context),
                                                const CustomSnackBar.success(
                                                  message:
                                                      'Xóa Dịch vụ thành công!',
                                                ),
                                                displayDuration:
                                                    const Duration(seconds: 0),
                                              );
                                              setState(() {
                                                servicesRequest.removeAt(index);
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
                                                    const Duration(seconds: 0),
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
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
