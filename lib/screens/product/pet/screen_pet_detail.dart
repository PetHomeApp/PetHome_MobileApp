// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_age.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_infor.dart';
import 'package:pethome_mobileapp/screens/chat/screen_chat_detail_with_shop.dart';
import 'package:pethome_mobileapp/screens/my/screen_favorite_pets.dart';
import 'package:pethome_mobileapp/screens/screen_all_rating.dart';
import 'package:pethome_mobileapp/services/api/cart_api.dart';
import 'package:pethome_mobileapp/services/api/chat_api.dart';
import 'package:pethome_mobileapp/services/api/product/pet_api.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/widgets/rate/sent_pet_rate_sheet.dart';
import 'package:readmore/readmore.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/widgets/rate/list_rate.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_detail.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PetDetailScreen extends StatefulWidget {
  const PetDetailScreen(
      {super.key,
      required this.idPet,
      required this.showCartIcon,
      required this.ageID});
  final String idPet;
  final int? ageID;
  final bool showCartIcon;

  @override
  // ignore: library_private_types_in_public_api
  _PetDetailScreenState createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  final _controller = PageController();
  final _currentPageNotifier = ValueNotifier<int>(1);

  late PetDetail petDetail;
  late List<String> imageUrlDescriptions;
  List<PetAge> petAge = List.empty(growable: true);

  bool loading = false;
  bool checkRated = false;

  bool hasMessage = false;
  bool isShop = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _currentPageNotifier.value = (_controller.page!.round() + 1);
    });
    getPetDetailAndCheckShop();

    PetApi().getPetAges().then((value) {
      setState(() {
        petAge = value;
      });
    });
  }

  Future<void> getPetDetailAndCheckShop() async {
    if (loading) {
      return;
    }

    loading = true;
    petDetail = await PetApi().getPetDetail(widget.idPet);
    checkRated = await PetApi().checkRated(widget.idPet);

    final checkIsShop = await ShopApi().checkIsRegisterShop();
    if (checkIsShop['isSuccess'] == true) {
      final dataResponse = await ShopApi().checkIsActiveShop();

      if (dataResponse['isSuccess'] == true) {
        if (petDetail.idShop == dataResponse['shopId']) {
          isShop = true;
        }
      }
    }

    // ignore: unnecessary_null_comparison
    if (petDetail == null) {
      loading = false;
      return;
    }

    if (mounted) {
      setState(() {
        imageUrlDescriptions = [];
        imageUrlDescriptions.add(petDetail.imageUrl.toString());
        imageUrlDescriptions.addAll(petDetail.imageUrlDescriptions);
        loading = false;
      });
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
                "Thông tin thú cưng",
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
                if (widget.showCartIcon)
                  IconButton(
                    icon: const Icon(Icons.favorite,
                        color: iconButtonColor, size: 30),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const FavoritePetsScreen(),
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
                                  petDetail.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  petDetail.shop.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${NumberFormat('#,##0', 'vi').format(petDetail.price)} VNĐ',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: priceColor,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: petDetail.inStock
                                            ? Colors.green
                                            : Colors.red,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        petDetail.inStock
                                            ? '  Còn hàng  '
                                            : '  Hết hàng  ',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
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
                                Icon(Icons.app_registration_sharp,
                                    color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Thông tin cơ bản',
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cân nặng: ${petDetail.weight} kg',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).hintColor,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 5),
                                Text(
                                    'Tuổi: ${petAge.firstWhere((element) => element.id == widget.ageID).name}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).hintColor,
                                        fontWeight: FontWeight.w500)),
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
                              petDetail.description,
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
                                Icon(Icons.location_city, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Thông tin cửa hàng',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 12),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          petDetail.shop.logo.toString()),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      petDetail.shop.name,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: buttonBackgroundColor),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: petDetail.shop.shopAddress.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        'Địa chỉ ${index + 1}: ${petDetail.shop.shopAddress[index].address}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
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
                                      petDetail.averageRate != 0.0
                                          ? "${petDetail.averageRate.toStringAsFixed(1)}/5.0"
                                          : "0.0/0.0",
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: buttonBackgroundColor),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "(${petDetail.totalRate} đánh giá)",
                                      style: const TextStyle(
                                          color: buttonBackgroundColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                RateList(rates: petDetail.rates),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => AllRatingScreen(
                                        id: petDetail.idPet,
                                        name: petDetail.name,
                                        imageUrl: petDetail.imageUrl,
                                        productType: 'pet',
                                        averageRate: petDetail.averageRate,
                                        totalRate: petDetail.totalRate,
                                      ),
                                    ));
                                  },
                                  child: Text(
                                    'Tất cả đánh giá (${petDetail.totalRate})',
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
                                                    child: SentPetRateWidget(
                                                        petId: widget.idPet),
                                                  ),
                                                );
                                              },
                                            );

                                            if (result != null &&
                                                result == true) {
                                              setState(() {
                                                checkRated = true;
                                                getPetDetailAndCheckShop();
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
                      if (isShop) {
                        showTopSnackBar(
                          // ignore: use_build_context_synchronously
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message:
                                'Xin lỗi! Sản phẩm này thuộc cửa hàng của bạn!',
                          ),
                          displayDuration: const Duration(seconds: 0),
                        );
                      } else {
                        ShopInfor shopInfor =
                            await getShopInfor(petDetail.idShop);

                        var res = await ChatApi()
                            .checkMessageWithShop(petDetail.idShop);

                        if (res['isSuccess'] == true) {
                          hasMessage = res['has_messages'];
                        } else {
                          //
                        }
                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailWithShopScreen(
                              avatar: shopInfor.logo,
                              name: shopInfor.name,
                              idShop: petDetail.idShop,
                              isEmpty: !hasMessage,
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
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () async {
                      if (isShop) {
                        showTopSnackBar(
                          // ignore: use_build_context_synchronously
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message:
                                'Xin lỗi! Sản phẩm này thuộc cửa hàng của bạn!',
                          ),
                          displayDuration: const Duration(seconds: 0),
                        );
                        return;
                      }
                      var result = await CartApi().addPetToCart(widget.idPet);
                      if (result['isSuccess'] == true) {
                        showTopSnackBar(
                          // ignore: use_build_context_synchronously
                          Overlay.of(context),
                          const CustomSnackBar.success(
                            message: 'Đã thêm vào danh sách yêu thích',
                          ),
                          displayDuration: const Duration(seconds: 0),
                        );
                      } else if (result['isSuccess'] == false &&
                          result['message'] == 'Pet already in cart') {
                        showTopSnackBar(
                          // ignore: use_build_context_synchronously
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message: 'Thú cưng đã có trong danh sách yêu thích',
                          ),
                          displayDuration: const Duration(seconds: 0),
                        );
                      } else {
                        showTopSnackBar(
                          // ignore: use_build_context_synchronously
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message: 'Lỗi khi thêm vào danh sách yêu thích',
                          ),
                          displayDuration: const Duration(seconds: 0),
                        );
                      }
                    },
                    child: Container(
                      color: buttonBackgroundColor,
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                            Text(
                              'Thêm vào yêu thích',
                              style: TextStyle(color: Colors.white),
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
