import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_detail_infor.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/enter_infor_widget.dart';

class ShopDetailInforScreen extends StatefulWidget {
  const ShopDetailInforScreen({super.key});

  @override
  State<ShopDetailInforScreen> createState() => _ShopDetailInforScreenState();
}

class _ShopDetailInforScreenState extends State<ShopDetailInforScreen> {
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopBusinessTypeController =
      TextEditingController();
  final TextEditingController _shopTaxCodeController = TextEditingController();
  final TextEditingController _shopOwnerNameController =
      TextEditingController();
  final TextEditingController _shopOwnerIdCardController =
      TextEditingController();

  late ShopDetailInfor _shopDetailInfor;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    getShopInfor();
  }

  Future<void> getShopInfor() async {
    if (loading) {
      return;
    }

    loading = true;
    final dataResponse = await ShopApi().getShopDetailInfor();

    if (dataResponse['isSuccess'] == true) {
      setState(() {
        loading = false;
        _shopDetailInfor = dataResponse['shopInfor'];

        _shopNameController.text = _shopDetailInfor.name;
        _shopBusinessTypeController.text = _shopDetailInfor.businessType;
        _shopTaxCodeController.text = _shopDetailInfor.taxCode;
        _shopOwnerNameController.text = _shopDetailInfor.ownerName;
        _shopOwnerIdCardController.text = _shopDetailInfor.idCard;
      });
    } else {
      setState(() {
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
                "Thông tin chi tiết cửa hàng",
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
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
                child: Column(children: [
                  InfoInputField(
                    label: 'Tên cửa hàng: (*)',
                    hintText: '',
                    controller: _shopNameController,
                    enabled: false,
                  ),
                  const SizedBox(height: 20.0),
                  InfoInputField(
                    label: 'Loại hình kinh doanh: (*)',
                    hintText: '',
                    controller: _shopBusinessTypeController,
                    enabled: false,
                  ),
                  const SizedBox(height: 20.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Logo cửa hàng: (*)',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60.0),
                          child: Image.network(
                            _shopDetailInfor.logo,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Image.asset(
                                  'lib/assets/pictures/placeholder_image.png',
                                  fit: BoxFit.cover);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  InfoInputField(
                    label: 'Mã số thuế: (*)',
                    hintText: '',
                    controller: _shopTaxCodeController,
                    enabled: false,
                  ),
                  const SizedBox(height: 20.0),
                  InfoInputField(
                    label: 'Tên chủ cửa hàng: (*)',
                    hintText: '',
                    controller: _shopOwnerNameController,
                    enabled: false,
                  ),
                  const SizedBox(height: 20.0),
                  InfoInputField(
                    label: 'Số CCCD: (*)',
                    hintText: '',
                    controller: _shopOwnerIdCardController,
                    enabled: false,
                  ),
                  const SizedBox(height: 20.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Mặt trước CCCD: (*)',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60.0),
                          child: Image.network(
                            _shopDetailInfor.frontIdCard,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Image.asset(
                                  'lib/assets/pictures/placeholder_image.png',
                                  fit: BoxFit.cover);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Mặt sau CCCD: (*)',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60.0),
                          child: Image.network(
                            _shopDetailInfor.backIdCard,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Image.asset(
                                  'lib/assets/pictures/placeholder_image.png',
                                  fit: BoxFit.cover);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                ]),
              ),
            ),
          );
  }
}
