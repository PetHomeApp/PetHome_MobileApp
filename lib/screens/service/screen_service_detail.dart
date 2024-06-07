import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_detail.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_infor.dart';
import 'package:pethome_mobileapp/screens/cart/screen_cart_homepage.dart';
import 'package:pethome_mobileapp/screens/chat/screen_chat_detail_with_shop.dart';
import 'package:pethome_mobileapp/screens/screen_all_rating.dart';
import 'package:pethome_mobileapp/services/api/service_api.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/rate/list_rate.dart';
import 'package:pethome_mobileapp/widgets/rate/sent_service_rate_sheet.dart';
import 'package:readmore/readmore.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({super.key, required this.idService});
  final String idService;

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final _controller = PageController();
  final _currentPageNotifier = ValueNotifier<int>(1);

  late ServiceDetail serviceDetail;
  late List<String> imageUrlDescriptions;

  bool loading = false;
  bool checkRated = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _currentPageNotifier.value = (_controller.page!.round() + 1);
    });
    getPetDetail();
  }

  Future<void> getPetDetail() async {
    if (loading) {
      return;
    }

    loading = true;
    serviceDetail = await ServiceApi().getServiceDetail(widget.idService);
    checkRated = await ServiceApi().checkRated(widget.idService);

    // ignore: unnecessary_null_comparison
    if (serviceDetail == null) {
      loading = false;
      return;
    }

    if (mounted) {
      setState(() {
        imageUrlDescriptions = [];
        imageUrlDescriptions.add(serviceDetail.picture);
        imageUrlDescriptions.addAll(serviceDetail.images);
        loading = false;
      });
    }
  }

  Future<bool> checkUserIsShop() async {
    if (loading) {
      return true;
    }

    loading = true;
    ShopApi shopApi = ShopApi();
    final dataResponse = await shopApi.checkIsActiveShop();

    if (dataResponse['isSuccess'] == true) {
      loading = false;
      if (serviceDetail.idShop == dataResponse['shopId']) {
        return true;
      } else {
        return false;
      }
    } else {
      loading = false;
      return true;
    }
  }

  Future<ShopInfor> getShopInfor(String idShop) async {
    if (loading) {
      return ShopInfor(
        idShop: '',
        name: '',
        logo: '',
        areas: [],
      );
    }

    loading = true;
    ShopApi shopApi = ShopApi();
    final dataResponse = await shopApi.getShopInfor(idShop);

    if (dataResponse['isSuccess'] == true) {
      loading = false;
      return ShopInfor.fromJson(dataResponse['shopInfor']);
    } else {
      loading = false;
      return ShopInfor(
        idShop: '',
        name: '',
        logo: '',
        areas: [],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: buttonBackgroundColor,
              ),
            ),
          )
        : Scaffold(
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
              title: const Text(
                "Thông tin dịch vụ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      gradientStartColor,
                      gradientMidColor,
                      gradientEndColor
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.shopping_cart,
                      color: iconButtonColor, size: 30),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CartHomePageScreen(),
                    ));
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            child: SizedBox(
                              height: 250,
                              child: Stack(
                                children: [
                                  PageView.builder(
                                    controller: _controller,
                                    itemCount: imageUrlDescriptions.length,
                                    itemBuilder: (context, index) {
                                      return Image.network(
                                        imageUrlDescriptions[index],
                                        height: 250,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return Image.asset(
                                            'lib/assets/pictures/placeholder_image.png',
                                            height: 250,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ValueListenableBuilder<int>(
                                        valueListenable: _currentPageNotifier,
                                        builder: (context, value, child) {
                                          return Text(
                                            '$value/${imageUrlDescriptions.length}',
                                            style: const TextStyle(
                                              color: buttonBackgroundColor,
                                              fontSize: 18,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  serviceDetail.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${NumberFormat('#,##0', 'vi').format(serviceDetail.minPrice)} VNĐ - ${NumberFormat('#,##0', 'vi').format(serviceDetail.maxPrice)} VNĐ',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: priceColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [gradientStartColor, gradientEndColor],
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                            child: const Row(
                              children: [
                                Icon(Icons.description, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Mô tả',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ReadMoreText(
                              serviceDetail.description,
                              trimLength: 250,
                              trimCollapsedText: "Xem thêm",
                              trimExpandedText: "Rút gọn",
                              delimiter: "...\n",
                              moreStyle: const TextStyle(
                                color: buttonBackgroundColor,
                                fontWeight: FontWeight.bold,
                              ),
                              lessStyle: const TextStyle(
                                color: buttonBackgroundColor,
                                fontWeight: FontWeight.bold,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [gradientStartColor, gradientEndColor],
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                            child: const Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Địa chỉ cửa hàng',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: serviceDetail.address.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    'Địa chỉ ${index + 1}: ${serviceDetail.address[index]}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [gradientStartColor, gradientEndColor],
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                            child: const Row(
                              children: [
                                Icon(Icons.comment, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Khách hàng đánh giá',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${serviceDetail.averageRate.toStringAsFixed(1)}/5.0",
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: buttonBackgroundColor),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "(${serviceDetail.totalRate} đánh giá)",
                                      style: const TextStyle(
                                          color: buttonBackgroundColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                RateList(rates: serviceDetail.rates),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => AllRatingScreen(
                                        id: serviceDetail.idService,
                                        name: serviceDetail.name,
                                        imageUrl: serviceDetail.picture,
                                        productType: 'service',
                                        averageRate: serviceDetail.averageRate,
                                        totalRate: serviceDetail.totalRate,
                                      ),
                                    ));
                                  },
                                  child: Text(
                                    'Tất cả đánh giá (${serviceDetail.totalRate})',
                                    style: const TextStyle(
                                      color: buttonBackgroundColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: buttonBackgroundColor,
                                  ),
                                  child: checkRated
                                      ? const Center(
                                          child: Text(
                                            'Bạn đã đánh giá sản phẩm này!',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () async {
                                            final result =
                                                await showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (BuildContext context) {
                                                return SingleChildScrollView(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom,
                                                    ),
                                                    child:
                                                        SentServiceRateWidget(
                                                            serviceId: widget
                                                                .idService),
                                                  ),
                                                );
                                              },
                                            );

                                            if (result != null &&
                                                result == true) {
                                              setState(() {
                                                checkRated = true;
                                                getPetDetail();
                                              });
                                            }
                                          },
                                          child: const Center(
                                            child: Text(
                                              'Viết đánh giá',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
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
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () async {
                      bool isShop = await checkUserIsShop();
                      if (isShop) {
                        showTopSnackBar(
                          // ignore: use_build_context_synchronously
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message:
                                'Xin lỗi! Sản phẩm này thuộc Cửa hàng của bạn!',
                          ),
                          displayDuration: const Duration(seconds: 0),
                        );
                      } else {
                        ShopInfor shopInfor =
                            await getShopInfor(serviceDetail.idShop);

                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailWithShopScreen(
                              avatar: shopInfor.logo,
                              name: shopInfor.name,
                              idShop: serviceDetail.idShop,
                              isEmpty: true,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      color: Colors.grey[100],
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.chat,
                              color: buttonBackgroundColor,
                            ),
                            Text(
                              'Liên hệ Shop',
                              style: TextStyle(color: buttonBackgroundColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
