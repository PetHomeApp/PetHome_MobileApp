import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_detail.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_classify.dart';
import 'package:pethome_mobileapp/screens/cart/screen_cart_homepage.dart';
import 'package:pethome_mobileapp/screens/screen_all_rating.dart';
import 'package:pethome_mobileapp/services/api/cart_api.dart';
import 'package:pethome_mobileapp/services/api/item_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/rate/list_rate.dart';
import 'package:pethome_mobileapp/widgets/rate/sent_item_rate_sheet.dart';
import 'package:readmore/readmore.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen(
      {super.key, required this.idItem, required this.showCartIcon});
  final String idItem;
  final bool showCartIcon;

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final _controller = PageController();
  final _currentPageNotifier = ValueNotifier<int>(1);

  late ItemDetail itemDetail;
  late List<String> imageUrlDescriptions;
  List<DetailItemClassify> detailItemClassifyList = [];

  bool loading = false;
  bool checkRated = false;
  int selectedDetail = 0;

  int price = 0;
  bool instock = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _currentPageNotifier.value = _controller.page!.round() + 1;
    });
    getItemDetail();
  }

  void getItemDetail() async {
    if (loading) {
      return;
    }

    loading = true;
    itemDetail = await ItemApi().getItemDetail(widget.idItem);
    checkRated = await ItemApi().checkRated(widget.idItem);

    // ignore: unnecessary_null_comparison
    if (itemDetail == null) {
      loading = false;
      return;
    }

   if (mounted) {
     setState(() {
      imageUrlDescriptions = [];
      imageUrlDescriptions.add(itemDetail.imageUrl.toString());
      imageUrlDescriptions.addAll(itemDetail.imageUrlDescriptions);

      detailItemClassifyList = itemDetail.details;
      detailItemClassifyList.sort((a, b) => a.orderItem.compareTo(b.orderItem));

      price = detailItemClassifyList[selectedDetail].price;
      instock = detailItemClassifyList[selectedDetail].instock;
      loading = false;
    });
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
                "Thông tin sản phẩm",
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
                                  itemDetail.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  itemDetail.shop.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 0,
                                        right: 10,
                                        top: 10,
                                        bottom: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          spacing: 8.0,
                                          runSpacing: 8.0,
                                          children: detailItemClassifyList
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            int index = entry.key;
                                            DetailItemClassify
                                                detailItemClassify =
                                                entry.value;

                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedDetail = index;
                                                  price =
                                                      detailItemClassify.price;
                                                  instock = detailItemClassify
                                                      .instock;
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 5, 10, 5),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: selectedDetail ==
                                                            index
                                                        ? buttonBackgroundColor
                                                        : Colors.grey,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Text(
                                                  '${detailItemClassify.size} ${itemDetail.unit}',
                                                  style: TextStyle(
                                                    color: selectedDetail ==
                                                            index
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
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${NumberFormat('#,##0', 'vi').format(price)} VNĐ',
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
                                        color:
                                            instock ? Colors.green : Colors.red,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        instock
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
                              itemDetail.description,
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
                                    // ignore: prefer_interpolation_to_compose_strings
                                    Text(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      itemDetail.averageRating
                                              .toStringAsFixed(1) +
                                          "/5.0",
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: buttonBackgroundColor),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "(${itemDetail.totalRate} đánh giá)",
                                      style: const TextStyle(
                                          color: buttonBackgroundColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                RateList(rates: itemDetail.rates),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => AllRatingScreen(
                                          id: itemDetail.idItem,
                                          name: itemDetail.name,
                                          imageUrl: itemDetail.imageUrl,
                                          productType: 'item',
                                          averageRate: itemDetail.averageRating,
                                          totalRate: itemDetail.totalRate),
                                    ));
                                  },
                                  child: Text(
                                    'Tất cả đánh giá (${itemDetail.totalRate})',
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
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom,
                                                      ),
                                                      child: SentItemRateWidget(
                                                        idItem: widget.idItem,
                                                      )),
                                                );
                                              },
                                            );

                                            if (result != null &&
                                                result == true) {
                                              setState(() {
                                                checkRated = true;
                                                getItemDetail();
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
                  flex: 10,
                  child: InkWell(
                    onTap: () {
                      // ignore: avoid_print
                      print('Chat with shop');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: const Border(
                          right: BorderSide(color: buttonBackgroundColor, width: 1.0),
                        ),
                      ),
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
                  flex: 10,
                  child: InkWell(
                    onTap: () async {
                      var result = await CartApi().addItemToCart(
                        widget.idItem,
                        detailItemClassifyList[selectedDetail].idItemDetail,
                      );
                      if (result['isSuccess'] == true) {
                        showTopSnackBar(
                          // ignore: use_build_context_synchronously
                          Overlay.of(context),
                          const CustomSnackBar.success(
                            message: 'Đã thêm vào giỏ hàng',
                          ),
                          displayDuration: const Duration(seconds: 0),
                        );
                      } else if (result['isSuccess'] == false &&
                          result['message'] == 'Item already in cart') {
                        showTopSnackBar(
                          // ignore: use_build_context_synchronously
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message: 'Sản phẩm đã có trong giỏ hàng',
                          ),
                          displayDuration: const Duration(seconds: 0),
                        );
                      } else {
                        showTopSnackBar(
                          // ignore: use_build_context_synchronously
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message: 'Lỗi khi thêm vào giỏ hàng',
                          ),
                          displayDuration: const Duration(seconds: 0),
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
                              Icons.shopping_cart,
                              color: buttonBackgroundColor,
                            ),
                            Text(
                              'Thêm vào Giỏ hàng',
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
                  flex: 15,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      color: buttonBackgroundColor,
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.shopping_bag,
                              color: Colors.white,
                            ),
                            Text(
                              'Mua ngay',
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
