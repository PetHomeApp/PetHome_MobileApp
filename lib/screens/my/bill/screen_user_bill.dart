import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/bill/model_bill.dart';
import 'package:pethome_mobileapp/screens/my/bill/screen_user_bill_detail.dart';
import 'package:pethome_mobileapp/services/api/bill_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/bill/user_bill_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UserBillScreen extends StatefulWidget {
  const UserBillScreen({super.key});

  @override
  State<UserBillScreen> createState() => _UserBillScreenState();
}

class _UserBillScreenState extends State<UserBillScreen>
    with SingleTickerProviderStateMixin {
  bool loading = false;

  List<BillItem> allBills = [];
  List<BillItem> successBills = [];
  List<BillItem> cancelBills = [];

  int currentPageAll = 0;
  int currentPageSuccess = 0;
  int currentPageCancel = 0;

  final ScrollController _scrollAllController = ScrollController();
  final ScrollController _scrollSuccessController = ScrollController();
  final ScrollController _scrollCancelController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollAllController.addListener(_listenerScrollAll);
    _scrollSuccessController.addListener(_listenerScrollSuccess);
    _scrollCancelController.addListener(_listenerScrollCancel);
    getBill();
  }

  void getBill() async {
    setState(() {
      loading = true;
    });

    List<BillItem> resAll =
        await BillApi().getListBillAll(currentPageAll * 10, 10);

    List<BillItem> resSuccess =
        await BillApi().getListBillSuccess(currentPageSuccess * 10, 10);

    List<BillItem> resCancel =
        await BillApi().getListBillCancel(currentPageCancel * 10, 10);

    if (resAll.isNotEmpty) {
      allBills.addAll(resAll);
      currentPageAll++;
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

  void _listenerScrollAll() {
    if (_scrollAllController.position.atEdge) {
      if (_scrollAllController.position.pixels != 0) {
        getAllBill();
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

  void getAllBill() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<BillItem> items =
        await BillApi().getListBillAll(currentPageAll * 10, 10);

    if (items.isEmpty) {
      loading = false;
      return;
    }

    if (mounted) {
      setState(() {
        allBills.addAll(items);
        currentPageAll++;
        loading = false;
      });
    }
  }

  void getSuccessBill() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<BillItem> items =
        await BillApi().getListBillSuccess(currentPageSuccess * 10, 10);

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
    final List<BillItem> items =
        await BillApi().getListBillCancel(currentPageCancel * 10, 10);

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
            length: 3,
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
                  "Danh sách đơn hàng",
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
                        Tab(text: 'Tất cả'),
                        Tab(text: 'Dơn đã nhận'),
                        Tab(text: 'Đơn hủy'),
                      ],
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  allBills.isEmpty
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
                              SizedBox(height: 10),
                              Text(
                                'Hãy mua hàng tại PetHome ngay nào!',
                                style: TextStyle(
                                  fontSize: 16,
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
                          itemCount: allBills.length,
                          controller: _scrollAllController,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserBillDetailScreen(
                                      billItem: allBills[index],
                                    ),
                                  ),
                                );
                              },
                              child: UserBillWidget(
                                billItem: allBills[index],
                                onDone: () async {
                                  if (allBills[index].status == 'delivered') {
                                    bool check = await BillApi()
                                        .updateStatusBillByUser(
                                            allBills[index].idBill, 'done');

                                    if (check) {
                                      showTopSnackBar(
                                        // ignore: use_build_context_synchronously
                                        Overlay.of(context),
                                        const CustomSnackBar.success(
                                          message:
                                              'Bạn đã xác nhận nhận hàng thành công!',
                                        ),
                                        displayDuration:
                                            const Duration(seconds: 0),
                                      );
                                      setState(() {
                                        currentPageAll = 0;
                                        currentPageSuccess = 0;
                                        currentPageCancel = 0;

                                        allBills.clear();
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
                                              'Xác nhận nhận hàng không thành công! Vui lòng thử lại sau!',
                                        ),
                                        displayDuration:
                                            const Duration(seconds: 0),
                                      );
                                    }
                                  } else {
                                    if (mounted) {
                                      showTopSnackBar(
                                        Overlay.of(context),
                                        const CustomSnackBar.error(
                                          message:
                                              'Bạn chưa thể xác nhận nhận hàng!',
                                        ),
                                        displayDuration:
                                            const Duration(seconds: 0),
                                      );
                                    }
                                  }
                                },
                                onCancel: () {
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
                                              if (allBills[index].status ==
                                                  'pending') {
                                                bool check = await BillApi()
                                                    .updateStatusBillByUser(
                                                        allBills[index].idBill,
                                                        'canceled');

                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();

                                                if (check) {
                                                  showTopSnackBar(
                                                    // ignore: use_build_context_synchronously
                                                    Overlay.of(context),
                                                    const CustomSnackBar
                                                        .success(
                                                      message:
                                                          'Bạn đã hủy đơn hàng thành công!',
                                                    ),
                                                    displayDuration:
                                                        const Duration(
                                                            seconds: 0),
                                                  );
                                                  setState(() {
                                                    currentPageAll = 0;
                                                    currentPageSuccess = 0;
                                                    currentPageCancel = 0;

                                                    allBills.clear();
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
                                              } else {
                                                showTopSnackBar(
                                                  // ignore: use_build_context_synchronously
                                                  Overlay.of(context),
                                                  const CustomSnackBar.error(
                                                    message:
                                                        'Đơn hàng đã được xử lý, không thể hủy!',
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
                                'Bạn không có đơn hàng nào đã nhận',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: buttonBackgroundColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Hãy mua hàng tại PetHome ngay nào!',
                                style: TextStyle(
                                  fontSize: 16,
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
                                    builder: (context) => UserBillDetailScreen(
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
                                                const SizedBox(height: 2),
                                                Text(
                                                  successBills[index].shopName,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color.fromARGB(
                                                          255, 84, 84, 84)),
                                                ),
                                                Text(
                                                  'Ngày đặt: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(successBills[index].createdAt).add(const Duration(hours: 7)))}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color.fromARGB(
                                                          255, 84, 84, 84)),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  'Tổng cộng: ${NumberFormat('#,##0', 'vi').format(successBills[index].totalPrice)} đ',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: priceColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Đã nhận hàng',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.green),
                                                    ),
                                                    SizedBox(width: 5),
                                                  ],
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
                              SizedBox(height: 10),
                              Text(
                                'Hãy mua hàng tại PetHome ngay nào!',
                                style: TextStyle(
                                  fontSize: 16,
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
                                    builder: (context) => UserBillDetailScreen(
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
                                                const SizedBox(height: 2),
                                                Text(
                                                  cancelBills[index].shopName,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color.fromARGB(
                                                          255, 84, 84, 84)),
                                                ),
                                                Text(
                                                  'Ngày đặt: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(cancelBills[index].createdAt).add(const Duration(hours: 7)))}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color.fromARGB(
                                                          255, 84, 84, 84)),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  'Tổng cộng: ${NumberFormat('#,##0', 'vi').format(cancelBills[index].totalPrice)} đ',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: priceColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Đã hủy',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.red),
                                                    ),
                                                    SizedBox(width: 5),
                                                  ],
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
