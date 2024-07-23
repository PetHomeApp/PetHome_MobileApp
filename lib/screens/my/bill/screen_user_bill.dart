import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/bill/model_bill.dart';
import 'package:pethome_mobileapp/screens/my/bill/screen_user_bill_detail.dart';
import 'package:pethome_mobileapp/screens/my/bill/screen_web_payment.dart';
import 'package:pethome_mobileapp/services/api/bill_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/bill/user_bill_widget.dart';
import 'package:pethome_mobileapp/widgets/bill/user_bill_widget_no_interact.dart';
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

  List<BillItem> newBills = [];
  List<BillItem> ortherBills = [];
  List<BillItem> successBills = [];
  List<BillItem> cancelBills = [];

  int currentPageNew = 0;
  int currentPageOrther = 0;
  int currentPageSuccess = 0;
  int currentPageCancel = 0;

  final ScrollController _scrollNewController = ScrollController();
  final ScrollController _scrollOrtherController = ScrollController();
  final ScrollController _scrollSuccessController = ScrollController();
  final ScrollController _scrollCancelController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollNewController.addListener(_listenerScrollNew);
    _scrollOrtherController.addListener(_listenerScrollOrther);
    _scrollSuccessController.addListener(_listenerScrollSuccess);
    _scrollCancelController.addListener(_listenerScrollCancel);
    getBill();
  }

  void getBill() async {
    setState(() {
      loading = true;
    });
    List<BillItem> resNew =
        await BillApi().getListBillNew(currentPageOrther * 10, 10);

    List<BillItem> resOrther =
        await BillApi().getListBillAll(currentPageOrther * 10, 10);

    List<BillItem> resSuccess =
        await BillApi().getListBillSuccess(currentPageSuccess * 10, 10);

    List<BillItem> resCancel =
        await BillApi().getListBillCancel(currentPageCancel * 10, 10);

    if (resNew.isNotEmpty) {
      newBills.addAll(resNew);
      currentPageNew++;
    }

    if (resOrther.isNotEmpty) {
      ortherBills.addAll(resOrther);
      currentPageOrther++;
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

  void _listenerScrollOrther() {
    if (_scrollOrtherController.position.atEdge) {
      if (_scrollOrtherController.position.pixels != 0) {
        getOrtherBill();
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
    final List<BillItem> items =
        await BillApi().getListBillNew(currentPageNew * 10, 10);

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

  void getOrtherBill() async {
    if (loading) {
      return;
    }

    loading = true;
    final List<BillItem> items =
        await BillApi().getListBillAll(currentPageOrther * 10, 10);

    if (items.isEmpty) {
      loading = false;
      return;
    }

    if (mounted) {
      setState(() {
        ortherBills.addAll(items);
        currentPageOrther++;
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
                        Tab(text: 'Đơn mới'),
                        Tab(text: 'Xử lí'),
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
                          itemCount: newBills.length,
                          controller: _scrollOrtherController,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserBillDetailScreen(
                                      billItem: newBills[index],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  UserBillWidget(
                                    billItem: newBills[index],
                                    onPayment: () async {
                                      String url = await BillApi()
                                          .createPaymentUrl(
                                              newBills[index].idBill);

                                      if (url.isNotEmpty) {
                                        Navigator.push(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                WebPaymentScreen(url: url),
                                          ),
                                        ).then((value) {
                                          setState(() {
                                            currentPageNew = 0;
                                            currentPageOrther = 0;
                                            currentPageSuccess = 0;
                                            currentPageCancel = 0;

                                            newBills.clear();
                                            ortherBills.clear();
                                            successBills.clear();
                                            cancelBills.clear();
                                          });
                                          getBill();
                                        });
                                      } else {
                                        showTopSnackBar(
                                          // ignore: use_build_context_synchronously
                                          Overlay.of(context),
                                          const CustomSnackBar.error(
                                            message:
                                                'Thanh toán không thành công! Vui lòng thử lại sau!',
                                          ),
                                          displayDuration:
                                              const Duration(seconds: 0),
                                        );
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
                                                  if (newBills[index].status ==
                                                      'pending') {
                                                    bool check = await BillApi()
                                                        .updateStatusBillByUser(
                                                            newBills[index]
                                                                .idBill,
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
                                                        currentPageNew = 0;
                                                        currentPageOrther = 0;
                                                        currentPageSuccess = 0;
                                                        currentPageCancel = 0;

                                                        newBills.clear();
                                                        ortherBills.clear();
                                                        successBills.clear();
                                                        cancelBills.clear();
                                                      });
                                                      getBill();
                                                    } else {
                                                      showTopSnackBar(
                                                        // ignore: use_build_context_synchronously
                                                        Overlay.of(context),
                                                        const CustomSnackBar
                                                            .error(
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
                                                      const CustomSnackBar
                                                          .error(
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
                                  const SizedBox(height: 10),
                                ],
                              ),
                            );
                          },
                        ),
                  ortherBills.isEmpty
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
                          itemCount: ortherBills.length,
                          controller: _scrollOrtherController,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserBillDetailScreen(
                                      billItem: ortherBills[index],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  UserBillWidgetNoInteract(
                                    billItem: ortherBills[index],
                                  ),
                                  const SizedBox(height: 10),
                                ],
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
                                'Bạn không có đơn hàng thành công nào',
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
                              child: Column(
                                children: [
                                  UserBillWidgetNoInteract(
                                    billItem: successBills[index],
                                  ),
                                  const SizedBox(height: 10),
                                ],
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
                              child: Column(
                                children: [
                                  UserBillWidgetNoInteract(
                                    billItem: cancelBills[index],
                                  ),
                                  const SizedBox(height: 10),
                                ],
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
