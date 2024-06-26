import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/bill/model_bill.dart';
import 'package:pethome_mobileapp/screens/shop/managershop/bill/screen_shop_bill_detail.dart';
import 'package:pethome_mobileapp/services/api/bill_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/bill/shop_new_bill_widget.dart';
import 'package:pethome_mobileapp/widgets/bill/shop_other_bill_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ShopBillScreen extends StatefulWidget {
  const ShopBillScreen({super.key});

  @override
  State<ShopBillScreen> createState() => _ShopBillScreenState();
}

class _ShopBillScreenState extends State<ShopBillScreen>
    with SingleTickerProviderStateMixin {
  bool loading = false;

  List<BillItem> newBills = [];
  List<BillItem> otherBills = [];
  List<BillItem> successBills = [];
  List<BillItem> cancelBills = [];

  int currentPageNew = 0;
  int currentPageOther = 0;
  int currentPageSuccess = 0;
  int currentPageCancel = 0;

  final ScrollController _scrollNewController = ScrollController();
  final ScrollController _scrollOtherController = ScrollController();
  final ScrollController _scrollSuccessController = ScrollController();
  final ScrollController _scrollCancelController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollNewController.addListener(_listenerScrollNew);
    _scrollOtherController.addListener(_listenerScrollOther);
    _scrollSuccessController.addListener(_listenerScrollSuccess);
    _scrollCancelController.addListener(_listenerScrollCancel);
    getBill();
  }

  void getBill() async {
    setState(() {
      loading = true;
    });
    List<BillItem> resNew = await BillApi()
        .getListStatusBillForShop(currentPageNew * 10, 10, 'pending');

    List<BillItem> resOther =
        await BillApi().getListOtherBillForShop(currentPageOther * 10, 10);

    List<BillItem> resSuccess = await BillApi()
        .getListStatusBillForShop(currentPageSuccess * 10, 10, 'done');

    List<BillItem> resCancel = await BillApi()
        .getListStatusBillForShop(currentPageCancel * 10, 10, 'canceled');

    if (resNew.isNotEmpty) {
      newBills.addAll(resNew);
      currentPageNew++;
    }
    if (resOther.isNotEmpty) {
      otherBills.addAll(resOther);
      currentPageOther++;
    }

    if (resSuccess.isNotEmpty) {
      successBills.addAll(resSuccess);
      currentPageSuccess++;
    }
    if (resCancel.isNotEmpty) {
      cancelBills.addAll(resCancel);
      currentPageCancel++;
    }
    setState(() {
      loading = false;
    });
  }

  void _listenerScrollNew() {
    if (_scrollNewController.position.atEdge) {
      if (_scrollNewController.position.pixels != 0) {
        getNewBill();
      }
    }
  }

  void _listenerScrollOther() {
    if (_scrollOtherController.position.atEdge) {
      if (_scrollOtherController.position.pixels != 0) {
        getOtherBill();
      }
    }
  }

  void _listenerScrollSuccess() {
    if (_scrollSuccessController.position.atEdge) {
      if (_scrollSuccessController.position.pixels != 0) {
        getSuccessBill();
      }
    }
  }

  void _listenerScrollCancel() {
    if (_scrollCancelController.position.atEdge) {
      if (_scrollCancelController.position.pixels != 0) {
        getCancelBill();
      }
    }
  }

  void getNewBill() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<BillItem> items = await BillApi()
        .getListStatusBillForShop(currentPageNew * 10, 10, 'pending');

    if (items.isEmpty) {
      loading = false;
      return;
    }

    if (mounted) {
      setState(() {
        newBills.addAll(items);
        currentPageNew++;
        loading = false;
      });
    }
  }

  void getOtherBill() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<BillItem> items =
        await BillApi().getListOtherBillForShop(currentPageOther * 10, 10);

    if (items.isEmpty) {
      loading = false;
      return;
    }

    if (mounted) {
      setState(() {
        otherBills.addAll(items);
        currentPageOther++;
        loading = false;
      });
    }
  }

  void getSuccessBill() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<BillItem> items = await BillApi()
        .getListStatusBillForShop(currentPageSuccess * 10, 10, 'done');

    if (items.isEmpty) {
      loading = false;
      return;
    }

    if (mounted) {
      setState(() {
        successBills.addAll(items);
        currentPageSuccess++;
        loading = false;
      });
    }
  }

  void getCancelBill() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<BillItem> items = await BillApi()
        .getListStatusBillForShop(currentPageCancel * 10, 10, 'canceled');

    if (items.isEmpty) {
      loading = false;
      return;
    }

    if (mounted) {
      setState(() {
        cancelBills.addAll(items);
        currentPageCancel++;
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
        : DefaultTabController(
            length: 4,
            child: Scaffold(
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
                  "Quản lí đơn hàng",
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
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Container(
                    color: Colors.white,
                    child: const TabBar(
                      indicatorColor: buttonBackgroundColor,
                      labelColor: buttonBackgroundColor,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(text: 'Đơn mới'),
                        Tab(text: 'Đang xử lí'),
                        Tab(text: 'Đơn xong'),
                        Tab(text: 'Đơn hủy'),
                      ],
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  newBills.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage(
                                    'lib/assets/pictures/icon_order.png'),
                                width: 50,
                                height: 50,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Bạn không có đơn hàng mới nào',
                                style: TextStyle(
                                  fontSize: 20,
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
                          itemCount: newBills.length,
                          controller: _scrollNewController,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShopBillDetailScreen(
                                      billItem: newBills[index],
                                    ),
                                  ),
                                );
                              },
                              child: ShopNewBillWidget(
                                billItem: newBills[index],
                                onConfirm: () async {
                                  bool check = await BillApi()
                                      .updateStatusBillByShop(
                                          newBills[index].idBill, 'preparing');

                                  if (check) {
                                    showTopSnackBar(
                                      // ignore: use_build_context_synchronously
                                      Overlay.of(context),
                                      const CustomSnackBar.success(
                                        message:
                                            'Bạn đã xác nhận đơn hàng thành công!',
                                      ),
                                      displayDuration:
                                          const Duration(seconds: 0),
                                    );
                                    setState(() {
                                      currentPageNew = 0;
                                      currentPageOther = 0;
                                      currentPageSuccess = 0;
                                      currentPageCancel = 0;

                                      newBills.clear();
                                      otherBills.clear();
                                      successBills.clear();
                                      cancelBills.clear();
                                    });
                                    getBill();
                                  } else {
                                    showTopSnackBar(
                                      // ignore: use_build_context_synchronously
                                      Overlay.of(context),
                                      const CustomSnackBar.error(
                                        message:
                                            'Xác nhận đơn hàng không thành công! Vui lòng thử lại sau!',
                                      ),
                                      displayDuration:
                                          const Duration(seconds: 0),
                                    );
                                  }
                                },
                                onCancel: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Xác nhận"),
                                        content: const Text(
                                            "Bạn có chắc chắn muốn hủy đơn hàng không không?"),
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
                                              bool check = await BillApi()
                                                  .updateStatusBillByShop(
                                                      newBills[index].idBill,
                                                      'canceled');

                                              // ignore: use_build_context_synchronously
                                              Navigator.of(context).pop();

                                              if (check) {
                                                showTopSnackBar(
                                                  // ignore: use_build_context_synchronously
                                                  Overlay.of(context),
                                                  const CustomSnackBar.success(
                                                    message:
                                                        'Bạn đã hủy đơn hàng thành công!',
                                                  ),
                                                  displayDuration:
                                                      const Duration(
                                                          seconds: 0),
                                                );
                                                setState(() {
                                                  currentPageNew = 0;
                                                  currentPageOther = 0;
                                                  currentPageSuccess = 0;
                                                  currentPageCancel = 0;

                                                  newBills.clear();
                                                  otherBills.clear();
                                                  successBills.clear();
                                                  cancelBills.clear();
                                                });
                                                getBill();
                                              } else {
                                                showTopSnackBar(
                                                  // ignore: use_build_context_synchronously
                                                  Overlay.of(context),
                                                  const CustomSnackBar.error(
                                                    message:
                                                        'Hủy đơn hàng không thành công! Vui lòng thử lại sau!',
                                                  ),
                                                  displayDuration:
                                                      const Duration(
                                                          seconds: 0),
                                                );
                                              }
                                            },
                                            child: const Text("Hủy",
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
                  otherBills.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage(
                                    'lib/assets/pictures/icon_order.png'),
                                width: 50,
                                height: 50,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Bạn không có đơn hàng nào',
                                style: TextStyle(
                                  fontSize: 20,
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
                          itemCount: otherBills.length,
                          controller: _scrollOtherController,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShopBillDetailScreen(
                                      billItem: otherBills[index],
                                    ),
                                  ),
                                );
                              },
                              child: ShopOtherBillWidget(
                                billItem: otherBills[index],
                                onConfirm: () {
                                  if (otherBills[index].status == 'preparing') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Xác nhận"),
                                          content: const Text(
                                              "Bạn đã vận chuyển đơn hàng này?"),
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
                                                bool check = await BillApi()
                                                    .updateStatusBillByShop(
                                                        otherBills[index]
                                                            .idBill,
                                                        'delivering');

                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();

                                                if (check) {
                                                  showTopSnackBar(
                                                    // ignore: use_build_context_synchronously
                                                    Overlay.of(context),
                                                    const CustomSnackBar
                                                        .success(
                                                      message:
                                                          'Cập nhật đơn hàng thành công!',
                                                    ),
                                                    displayDuration:
                                                        const Duration(
                                                            seconds: 0),
                                                  );
                                                  setState(() {
                                                    otherBills[index].status =
                                                        'delivering';
                                                  });
                                                } else {
                                                  showTopSnackBar(
                                                    // ignore: use_build_context_synchronously
                                                    Overlay.of(context),
                                                    const CustomSnackBar.error(
                                                      message:
                                                          'Cập nhật đơn hàng không thành công! Vui lòng thử lại sau!',
                                                    ),
                                                    displayDuration:
                                                        const Duration(
                                                            seconds: 0),
                                                  );
                                                }
                                              },
                                              child: const Text("Xác nhận",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 46, 159, 71))),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (otherBills[index].status ==
                                      'delivering') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Xác nhận"),
                                          content: const Text(
                                              "Bạn đã giao hàng thành công?"),
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
                                                bool check = await BillApi()
                                                    .updateStatusBillByShop(
                                                        otherBills[index]
                                                            .idBill,
                                                        'delivered');

                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();

                                                if (check) {
                                                  showTopSnackBar(
                                                    // ignore: use_build_context_synchronously
                                                    Overlay.of(context),
                                                    const CustomSnackBar
                                                        .success(
                                                      message:
                                                          'Cập nhật đơn hàng thành công!',
                                                    ),
                                                    displayDuration:
                                                        const Duration(
                                                            seconds: 0),
                                                  );
                                                  setState(() {
                                                    otherBills[index].status =
                                                        'delivered';
                                                  });
                                                } else {
                                                  showTopSnackBar(
                                                    // ignore: use_build_context_synchronously
                                                    Overlay.of(context),
                                                    const CustomSnackBar.error(
                                                      message:
                                                          'Cập nhật đơn hàng không thành công! Vui lòng thử lại sau!',
                                                    ),
                                                    displayDuration:
                                                        const Duration(
                                                            seconds: 0),
                                                  );
                                                }
                                              },
                                              child: const Text("Xác nhận",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 46, 159, 71))),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Xác nhận"),
                                          content: const Text(
                                              "Bạn đã hoàn thành đơn hàng này?"),
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
                                                bool check = await BillApi()
                                                    .updateStatusBillByShop(
                                                        otherBills[index]
                                                            .idBill,
                                                        'done');

                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();

                                                if (check) {
                                                  showTopSnackBar(
                                                    // ignore: use_build_context_synchronously
                                                    Overlay.of(context),
                                                    const CustomSnackBar
                                                        .success(
                                                      message:
                                                          'Cập nhật đơn hàng thành công!',
                                                    ),
                                                    displayDuration:
                                                        const Duration(
                                                            seconds: 0),
                                                  );
                                                  setState(() {
                                                    otherBills.removeAt(index);
                                                  });
                                                } else {
                                                  showTopSnackBar(
                                                    // ignore: use_build_context_synchronously
                                                    Overlay.of(context),
                                                    const CustomSnackBar.error(
                                                      message:
                                                          'Cập nhật đơn hàng không thành công! Vui lòng thử lại sau!',
                                                    ),
                                                    displayDuration:
                                                        const Duration(
                                                            seconds: 0),
                                                  );
                                                }
                                              },
                                              child: const Text("Xác nhận",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 46, 159, 71))),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                  successBills.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage(
                                    'lib/assets/pictures/icon_order.png'),
                                width: 50,
                                height: 50,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Bạn không có đơn hàng nào thành công',
                                style: TextStyle(
                                  fontSize: 20,
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
                          itemCount: successBills.length,
                          controller: _scrollSuccessController,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShopBillDetailScreen(
                                      billItem: successBills[index],
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  color: Colors.grey[100],
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            child: Image.network(
                                              successBills[index]
                                                  .itemImage
                                                  .toString(),
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return Image.asset(
                                                  'lib/assets/pictures/placeholder_image.png',
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  successBills[index]
                                                      .itemName
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  'Ngày đặt: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(successBills[index].createdAt).add(const Duration(hours: 7)))}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color.fromARGB(
                                                          255, 84, 84, 84)),
                                                ),
                                                Text(
                                                  'Tổng cộng: ${NumberFormat('#,##0', 'vi').format(successBills[index].totalPrice)} đ',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: priceColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${successBills[index].paymentMethod}  -  ',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              buttonBackgroundColor),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      successBills[index]
                                                                  .paymentStatus ==
                                                              'pending'
                                                          ? 'Chưa thanh toán'
                                                          : 'Đã thanh toán',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: successBills[
                                                                          index]
                                                                      .paymentStatus ==
                                                                  'pending'
                                                              ? Colors.red
                                                              : buttonBackgroundColor),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                const Text(
                                                  'Đã hoàn thành',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                  cancelBills.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage(
                                    'lib/assets/pictures/icon_order.png'),
                                width: 50,
                                height: 50,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Bạn không có đơn hàng nào bị hủy',
                                style: TextStyle(
                                  fontSize: 20,
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
                          itemCount: cancelBills.length,
                          controller: _scrollCancelController,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShopBillDetailScreen(
                                      billItem: cancelBills[index],
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  color: Colors.grey[100],
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            child: Image.network(
                                              cancelBills[index]
                                                  .itemImage
                                                  .toString(),
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return Image.asset(
                                                  'lib/assets/pictures/placeholder_image.png',
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  cancelBills[index]
                                                      .itemName
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  'Ngày đặt: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(cancelBills[index].createdAt).add(const Duration(hours: 7)))}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color.fromARGB(
                                                          255, 84, 84, 84)),
                                                ),
                                                Text(
                                                  'Tổng cộng: ${NumberFormat('#,##0', 'vi').format(cancelBills[index].totalPrice)} đ',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: priceColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                const Text(
                                                  'Đã hủy',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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
