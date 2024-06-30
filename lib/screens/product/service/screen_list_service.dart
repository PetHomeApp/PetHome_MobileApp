import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_in_card.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_type_detail.dart';
import 'package:pethome_mobileapp/screens/product/service/screen_service_detail.dart';
import 'package:pethome_mobileapp/screens/product/service/screen_service_search_filter.dart';
import 'package:pethome_mobileapp/services/api/product/service_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/product/service/service_shop_card.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ListServiceScreen extends StatefulWidget {
  const ListServiceScreen(
      {super.key, required this.idServiceType, required this.title});

  final int idServiceType;
  final String title;

  @override
  State<ListServiceScreen> createState() => _ListServiceScreenState();
}

class _ListServiceScreenState extends State<ListServiceScreen> {
  List<ServiceTypeDetail> listServiceTypeDetail = List.empty(growable: true);
  List<ServiceInCard> listServiceInCard = List.empty(growable: true);

  late ServiceTypeDetail selectedServiceTypeDetail;
  bool isChoose = false;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  int currentPage = 0;
  bool loading = false;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listenerScroll);
    getListServiceTypeDetailAndListStore();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _listenerScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        getListServiceInCard();
      }
    }
  }

  Future<void> getListServiceTypeDetailAndListStore() async {
    if (loading) {
      return;
    }

    loading = true;

    final List<ServiceTypeDetail> serviceTypeDetail =
        await ServiceApi().getServiceTypeDetail(widget.idServiceType);

    serviceTypeDetail.sort((a, b) => a.idServiceTypeDetail.compareTo(b.idServiceTypeDetail));

    if (serviceTypeDetail.isEmpty) {
      setState(() {
        loading = false;
        return;
      });
    }

    setState(() {
      listServiceTypeDetail.addAll(serviceTypeDetail);
      selectedServiceTypeDetail = listServiceTypeDetail[0];
      loading = false;
      return;
    });
    getListServiceInCard();
  }

  Future<void> getListServiceInCard() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<ServiceInCard> serviceInCard = await ServiceApi()
        .getServiceInCard(selectedServiceTypeDetail.idServiceTypeDetail, 40,
            currentPage * 40);

    if (serviceInCard.isEmpty) {
      setState(() {
        loading = false;
        return;
      });
    }

    setState(() {
      if (isChoose) {
        listServiceInCard.addAll(serviceInCard);
        currentPage++;
        isChoose = false;
      } else {
        listServiceInCard.addAll(serviceInCard);
        currentPage++;
      }
      loading = false;
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ServiceSearchAndFulterScreen(
                      serviceTypeId:
                          selectedServiceTypeDetail.idServiceTypeDetail,
                      title: searchKey),
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.format_list_bulleted,
                color: iconButtonColor, size: 30),
            onPressed: () {
              scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: appColor),
            )
          : listServiceInCard.isEmpty
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
                        'Ứng dụng chưa cung cấp dịch vụ này!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: buttonBackgroundColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'PetHome xin lỗi quý khách!',
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
                  controller: _scrollController,
                  itemCount: listServiceInCard.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ServiceDetailScreen(
                              idService: listServiceInCard[index].idService),
                        ));
                      },
                      child: ServiceShopCard(
                          serviceInCard: listServiceInCard[index]),
                    );
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
                        'Danh mục Dịch vụ',
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
                      children: listServiceTypeDetail.map((serviceTypeDetail) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 10, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isChoose = true;
                                    currentPage = 0;
                                    listServiceInCard.clear();

                                    selectedServiceTypeDetail =
                                        serviceTypeDetail;
                                    getListServiceInCard();
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    serviceTypeDetail.name,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: serviceTypeDetail
                                                    .idServiceTypeDetail ==
                                                selectedServiceTypeDetail
                                                    .idServiceTypeDetail
                                            ? buttonBackgroundColor
                                            : Colors.grey[600]),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
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
