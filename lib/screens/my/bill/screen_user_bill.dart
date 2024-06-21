import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/bill/model_bill.dart';
import 'package:pethome_mobileapp/screens/my/bill/screen_user_bill_detail.dart';
import 'package:pethome_mobileapp/services/api/bill_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

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
                                              allBills[index]
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
                                                  allBills[index]
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
                                                  allBills[index].shopName,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color.fromARGB(
                                                          255, 84, 84, 84)),
                                                ),
                                                Text(
                                                  'Ngày đặt: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(allBills[index].createdAt).add(const Duration(hours: 7)))}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color.fromARGB(
                                                          255, 84, 84, 84)),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  'Tổng cộng: ${NumberFormat('#,##0', 'vi').format(allBills[index].totalPrice)} đ',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: priceColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      allBills[index].status ==
                                                              'pending'
                                                          ? 'Đang chờ xác nhận'
                                                          : allBills[index]
                                                                      .status ==
                                                                  'preparing'
                                                              ? 'Đang chuẩn bị'
                                                              : allBills[index]
                                                                          .status ==
                                                                      'delivering'
                                                                  ? 'Đang giao hàng'
                                                                  : 'Đã giao hàng',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: allBills[index]
                                                                      .status ==
                                                                  'pending'
                                                              ? const Color
                                                                  .fromARGB(255,
                                                                  255, 38, 0)
                                                              : allBills[index]
                                                                          .status ==
                                                                      'preparing'
                                                                  ? buttonBackgroundColor
                                                                  : allBills[index]
                                                                              .status ==
                                                                          'delivering'
                                                                      ? buttonBackgroundColor
                                                                      : Colors
                                                                          .green),
                                                    ),
                                                    const SizedBox(width: 5),
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
