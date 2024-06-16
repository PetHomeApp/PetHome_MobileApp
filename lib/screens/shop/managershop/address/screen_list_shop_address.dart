import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_address.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_infor.dart';
import 'package:pethome_mobileapp/screens/shop/managershop/address/screen_add_shop_address.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ListShopAddressScreen extends StatefulWidget {
  const ListShopAddressScreen({super.key, required this.shopId});
  final String shopId;

  @override
  State<ListShopAddressScreen> createState() => _ListShopAddressScreenState();
}

class _ListShopAddressScreenState extends State<ListShopAddressScreen> {
  late ShopInfor shopInfor;
  List<ShopAddress> shopAddress = List.empty(growable: true);

  bool loading = false;

  @override
  void initState() {
    super.initState();
    getShopAddress();
  }

  Future<void> getShopAddress() async {
    if (loading) {
      return;
    }

    setState(() {
      loading = true;
    });

    var dataResponse = await ShopApi().getShopInfor(widget.shopId);

    if (dataResponse['isSuccess'] == false) {
      loading = false;
      return;
    }

    shopInfor = ShopInfor.fromJson(dataResponse['shopInfor']);

    if (mounted) {
      setState(() {
        shopAddress = shopInfor.areas;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Danh sách chi nhánh cửa hàng",
          style: TextStyle(
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 30,
              color: iconButtonColor,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => const AddShopAddressScreen(),
              ))
                  .then((value) {
                getShopAddress();
              });
            },
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: buttonBackgroundColor,
              ),
            )
          : shopAddress.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage(
                            'lib/assets/pictures/icon_no_address.png'),
                        width: 70,
                        height: 70,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Bạn chưa có chi nhánh nào!',
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
                  itemCount: shopAddress.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.3,
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              if (shopAddress.length == 1) {
                                showTopSnackBar(
                                  // ignore: use_build_context_synchronously
                                  Overlay.of(context),
                                  const CustomSnackBar.error(
                                    message:
                                        'Cửa hàng phải có ít nhất một chi nhánh!',
                                  ),
                                  displayDuration: const Duration(seconds: 0),
                                );
                                return;
                              }

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Xác nhận"),
                                      content: const Text(
                                          "Bạn có chắc chắn muốn xóa địa chỉ này không?"),
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
                                                .deleteAddress(
                                                    shopAddress[index]
                                                        .idAddress);
                                            if (res['isSuccess']) {
                                              showTopSnackBar(
                                                // ignore: use_build_context_synchronously
                                                Overlay.of(context),
                                                const CustomSnackBar.success(
                                                  message:
                                                      'Xóa địa chỉ thành công!',
                                                ),
                                                displayDuration:
                                                    const Duration(seconds: 0),
                                              );
                                              setState(() {
                                                shopAddress.removeAt(index);
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
                                  });
                            },
                            icon: Icons.delete,
                            label: "Xóa",
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Container(
                          color: Colors.grey[100],
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: SizedBox(
                              height: 120,
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Địa chỉ:  ${shopAddress[index].address}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                  Text(
                                    "Khu vực:  ${shopAddress[index].area}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: buttonBackgroundColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
