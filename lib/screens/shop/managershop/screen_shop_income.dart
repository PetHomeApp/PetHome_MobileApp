import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/bill/model_bill.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ShopIncomeScreen extends StatefulWidget {
  const ShopIncomeScreen({super.key});

  @override
  State<ShopIncomeScreen> createState() => _ShopIncomeScreenState();
}

class _ShopIncomeScreenState extends State<ShopIncomeScreen> {
  List<BillItem> billItems = List.empty(growable: true);

  final ScrollController _scrollController = ScrollController();

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  int currentPage = 0;
  bool loading = false;

  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();

  Future<void> _selectDateStart(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        _startDateController.text =
            "${picked.day.toString().padLeft(2, "0")}-${picked.month.toString().padLeft(2, "0")}-${picked.year.toString()}";
      });
    }
  }

  Future<void> _selectDateEnd(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
        _endDateController.text =
            "${picked.day.toString().padLeft(2, "0")}-${picked.month.toString().padLeft(2, "0")}-${picked.year.toString()}";
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
          "Quản lý doanh thu",
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
        actions: <Widget>[
          IconButton(
            icon:
                const Icon(Icons.search_off, color: iconButtonColor, size: 30),
            onPressed: () {
              if (_startDateController.text.isEmpty ||
                  _endDateController.text.isEmpty) {
                showTopSnackBar(
                  // ignore: use_build_context_synchronously
                  Overlay.of(context),
                  const CustomSnackBar.error(
                    message: 'Vui lòng chọn ngày bắt đầu và ngày kết thúc',
                  ),
                  displayDuration: const Duration(seconds: 0),
                );
                return;
              }

              if (_selectedStartDate.isAfter(_selectedEndDate)) {
                showTopSnackBar(
                  // ignore: use_build_context_synchronously
                  Overlay.of(context),
                  const CustomSnackBar.error(
                    message: 'Ngày bắt đầu không thể sau ngày kết thúc',
                  ),
                  displayDuration: const Duration(seconds: 0),
                );
                return;
              }
            },
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Ngày bắt đầu:',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      TextField(
                        controller: _startDateController,
                        readOnly: true,
                        onTap: () => _selectDateStart(context),
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 0.75,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 0.75,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: buttonBackgroundColor,
                              width: 1.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 12.0),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Ngày kết thúc:',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      TextField(
                        controller: _endDateController,
                        readOnly: true,
                        onTap: () => _selectDateEnd(context),
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 0.75,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 0.75,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: buttonBackgroundColor,
                              width: 1.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 12.0),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
                loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              buttonBackgroundColor),
                        ),
                      )
                    : billItems.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Center(
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
                                    'Hãy lựa chọn thời gian khác để tra cứu!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: buttonBackgroundColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        // : ListView.builder(
                        //     shrinkWrap: true,
                        //     physics: const NeverScrollableScrollPhysics(),
                        //     itemCount: blogs.length,
                        //     itemBuilder: (context, index) {
                        //       return PersonalBlogCard(blog: blogs[index]);
                        //     },
                        //   ),
                        : Container(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: const Border(
                  right: BorderSide(color: buttonBackgroundColor, width: 1.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //SPACE BETWEEN

                  children: <Widget>[
                    Text(
                      'Tổng doanh thu:',
                      style: TextStyle(
                          color: buttonBackgroundColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      '0 VNĐ',
                      style: TextStyle(
                          color: buttonBackgroundColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
