import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_detail.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_address.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_infor.dart';
import 'package:pethome_mobileapp/screens/shop/managershop/manager/service/screen_service_gallery.dart';
import 'package:pethome_mobileapp/services/api/service_api.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/enter_infor_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UpdateServiceScreen extends StatefulWidget {
  const UpdateServiceScreen({super.key, required this.idService});

  final String idService;

  @override
  State<UpdateServiceScreen> createState() => _UpdateServiceScreenState();
}

class _UpdateServiceScreenState extends State<UpdateServiceScreen> {
  final TextEditingController _serviceMinPriceController =
      TextEditingController();
  final TextEditingController _serviceMaxPriceController =
      TextEditingController();

  late ServiceDetail serviceDetail;

  List<ShopAddress> listShopAddress = List.empty(growable: true);
  List<String> listIdAddress = List.empty(growable: true);
  final Map<String, bool> _checkedAddresses = {};

  bool loading = false;

  @override
  void initState() {
    super.initState();
    getServiceDetail();
  }

  Future<void> getServiceDetail() async {
    if (loading) {
      return;
    }

    loading = true;
    serviceDetail = await ServiceApi().getServiceDetail(widget.idService);

    // ignore: unnecessary_null_comparison
    if (serviceDetail == null) {
      loading = false;
      return;
    }

    final dataResponse = await ShopApi().getShopInfor(serviceDetail.idShop);
    ShopInfor shopInforData = ShopInfor.fromJson(dataResponse['shopInfor']);

    listShopAddress = shopInforData.areas.toList();

    for (var address in serviceDetail.address) {
      listIdAddress.add(address.idAddress);
    }

    for (var address in listShopAddress) {
      if (listIdAddress.contains(address.idAddress)) {
        _checkedAddresses[address.idAddress] = true;
      } else {
        _checkedAddresses[address.idAddress] = false;
      }
    }

    if (mounted) {
      setState(() {
        _serviceMinPriceController.text = serviceDetail.minPrice.toString();
        _serviceMaxPriceController.text = serviceDetail.maxPrice.toString();
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
                "Chỉnh sửa thông tin dịch vụ",
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
                  icon:
                      const Icon(Icons.save, color: iconButtonColor, size: 30),
                  onPressed: () async {
                    if (_serviceMinPriceController.text.isEmpty ||
                        _serviceMaxPriceController.text.isEmpty) {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message: 'Vui lòng nhập đầy đủ thông tin',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                      return;
                    }

                    if (_checkedAddresses.values
                        .every((element) => element == false)) {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message:
                              'Vui lòng chọn ít nhất một địa chỉ cung cấp dịch vụ',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                      return;
                    }

                    if (int.parse(_serviceMinPriceController.text) >
                        int.parse(_serviceMaxPriceController.text)) {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message: 'Giá thấp nhất phải nhỏ hơn giá cao nhất',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                      return;
                    }

                    if (int.parse(_serviceMinPriceController.text) < 0 ||
                        int.parse(_serviceMaxPriceController.text) < 0) {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message: 'Giá không được nhỏ hơn 0',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                      return;
                    }

                    if (int.parse(_serviceMinPriceController.text) ==
                            serviceDetail.minPrice &&
                        int.parse(_serviceMaxPriceController.text) ==
                            serviceDetail.maxPrice &&
                        _checkedAddresses.keys.every((element) =>
                            _checkedAddresses[element] == true
                                ? listIdAddress.contains(element)
                                : !listIdAddress.contains(element))) {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message: 'Vui lòng thay đổi thông tin trước khi lưu',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                      return;
                    }

                    if (int.parse(_serviceMinPriceController.text) !=
                            serviceDetail.minPrice ||
                        int.parse(_serviceMaxPriceController.text) !=
                            serviceDetail.maxPrice) {
                      var result = await ShopApi().updatePriceService(
                        widget.idService,
                        int.parse(_serviceMinPriceController.text),
                        int.parse(_serviceMaxPriceController.text),
                      );

                      if (result['isSuccess'] == false) {
                        showTopSnackBar(
                          // ignore: use_build_context_synchronously
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message: 'Cập nhật dịch vụ thất bại',
                          ),
                          displayDuration: const Duration(seconds: 0),
                        );
                        return;
                      }
                    }

                    List<String> listAdd = [];
                    List<String> listRemove = [];

                    if (!_checkedAddresses.keys.every((element) =>
                        _checkedAddresses[element] == true
                            ? listIdAddress.contains(element)
                            : !listIdAddress.contains(element))) {
                      for (var address in _checkedAddresses.keys) {
                        if (_checkedAddresses[address] == true &&
                            !listIdAddress.contains(address)) {
                          listAdd.add(address);
                        } else if (_checkedAddresses[address] == false &&
                            listIdAddress.contains(address)) {
                          listRemove.add(address);
                        }
                      }

                      var result = await ShopApi().updateAddressService(
                        widget.idService,
                        listAdd,
                        listRemove,
                      );

                      if (result['isSuccess'] == false) {
                        showTopSnackBar(
                          // ignore: use_build_context_synchronously
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message: 'Cập nhật dịch vụ thất bại',
                          ),
                          displayDuration: const Duration(seconds: 0),
                        );
                        return;
                      }
                    }

                    showTopSnackBar(
                      // ignore: use_build_context_synchronously
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        message: 'Cập nhật dịch vụ thành công',
                      ),
                      displayDuration: const Duration(seconds: 0),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            body: Padding(
              padding:
                  const EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      serviceDetail.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: buttonBackgroundColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  InfoInputField(
                    label: 'Giá thấp nhất: (*)',
                    hintText: '',
                    controller: _serviceMinPriceController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20.0),
                  InfoInputField(
                    label: 'Giá cao nhất: (*)',
                    hintText: '',
                    controller: _serviceMaxPriceController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Lựa chọn chi nhánh cung cấp dịch vụ: (*)',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ...listShopAddress.map((address) {
                    return CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(address.address),
                      value: _checkedAddresses[address.idAddress],
                      activeColor: buttonBackgroundColor,
                      onChanged: (bool? value) {
                        setState(() {
                          _checkedAddresses[address.idAddress] = value!;
                        });
                      },
                    );
                  }),
                  const SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceGalleryScreen(
                                serviceId: widget.idService),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        'Thư viện ảnh',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          );
  }
}
