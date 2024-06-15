import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_request.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_type.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_type_detail.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_address.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_infor.dart';
import 'package:pethome_mobileapp/services/api/service_api.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/enter_infor_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key, required this.shopId});
  final String shopId;

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  List<ServiceType> serviceTypes = List.empty(growable: true);
  List<ServiceTypeDetail> serviceTypeDetails = List.empty(growable: true);

  List<ShopAddress> shopAddresses = List.empty(growable: true);
  final Map<String, bool> _checkedAddresses = {};

  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _serviceDescriptionController =
      TextEditingController();

  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  XFile? mainImage;
  List<XFile?> listImages = List.empty(growable: true);

  bool loading = false;

  late int selectedServiceType;
  late int selectedServiceTypeDetail;

  int maxLength = 2000;

  @override
  void initState() {
    super.initState();
    getInformation();
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _serviceDescriptionController.dispose();
    super.dispose();
  }

  Future<void> getInformation() async {
    if (loading) {
      return;
    }

    loading = true;

    final typeServiceDataResponse = await ServiceApi().getServiceType();
    final dataResponse = await ShopApi().getShopInfor(widget.shopId);

    ShopInfor shopInforData = ShopInfor.fromJson(dataResponse['shopInfor']);

    serviceTypes = typeServiceDataResponse.toList()
      ..sort((a, b) => a.idServiceType.compareTo(b.idServiceType));

    serviceTypeDetails = serviceTypes[0].details.toList()
      ..sort((a, b) => a.idServiceTypeDetail.compareTo(b.idServiceTypeDetail));

    shopAddresses = shopInforData.areas.toList();
    for (var address in shopAddresses) {
      _checkedAddresses[address.idAddress] = false;
    }

    setState(() {
      selectedServiceType = serviceTypes[0].idServiceType;
      selectedServiceTypeDetail = serviceTypeDetails[0].idServiceTypeDetail;
      loading = false;
    });
  }

  Future<void> _pickImage() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage = await showDialog<XFile>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn hình ảnh'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(
                  // ignore: use_build_context_synchronously
                  context,
                  await _picker.pickImage(source: ImageSource.camera));
            },
            child: const Text('Chụp hình',
                style: TextStyle(color: buttonBackgroundColor)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(
                  // ignore: use_build_context_synchronously
                  context,
                  await _picker.pickImage(source: ImageSource.gallery));
            },
            child: const Text('Chọn từ album',
                style: TextStyle(color: buttonBackgroundColor)),
          ),
        ],
      ),
    );

    if (pickedImage != null) {
      setState(() {
        mainImage = pickedImage;
      });
    }
  }

  Future _addImage() async {
    if (listImages.length >= 4) {
      showTopSnackBar(
        // ignore: use_build_context_synchronously
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Chỉ được chọn tối đa 4 hình ảnh!',
        ),
        displayDuration: const Duration(seconds: 0),
      );
      return;
    }

    final XFile? pickedImage = await showDialog<XFile>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn hình ảnh'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(
                  // ignore: use_build_context_synchronously
                  context,
                  await ImagePicker().pickImage(source: ImageSource.camera));
            },
            child: const Text('Chụp hình',
                style: TextStyle(color: buttonBackgroundColor)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(
                  // ignore: use_build_context_synchronously
                  context,
                  await ImagePicker().pickImage(source: ImageSource.gallery));
            },
            child: const Text('Chọn từ album',
                style: TextStyle(color: buttonBackgroundColor)),
          ),
        ],
      ),
    );

    if (pickedImage != null) {
      setState(() {
        listImages.add(pickedImage);
      });
    }
  }

  Future<void> _deleteImage() async {
    if (listImages.isEmpty) {
      showTopSnackBar(
        // ignore: use_build_context_synchronously
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Chưa có hình ảnh nào được chọn!',
        ),
        displayDuration: const Duration(seconds: 0),
      );
      return;
    }
    setState(() {
      listImages.removeLast();
    });
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
                "Thêm dịch vụ",
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
                    if (mainImage == null || mainImage?.path == '') {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message: 'Chưa chọn ảnh đại diện!',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                      return;
                    }

                    if (listImages.isEmpty) {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message: 'Chưa chọn ảnh mô tả!',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                      return;
                    }

                    if (_serviceNameController.text.isEmpty ||
                        _serviceDescriptionController.text.isEmpty ||
                        _minPriceController.text.isEmpty ||
                        _maxPriceController.text.isEmpty) {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message: 'Vui lòng điền đầy đủ thông tin!',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                      return;
                    }

                    final int minPrice = int.parse(_minPriceController.text);

                    final int maxPrice = int.parse(_maxPriceController.text);

                    if (minPrice <= 0 || maxPrice <= 0) {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message: 'Giá không hợp lệ!',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                      return;
                    }

                    if (_serviceDescriptionController.text.length > maxLength) {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message: 'Mô tả quá dài!',
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
                          message: 'Chưa chọn khu vực cung cấp dịch vụ!',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                      return;
                    }

                    ServiceIsRequest service = ServiceIsRequest(
                      name: _serviceNameController.text,
                      idServiceDetail: selectedServiceTypeDetail.toString(),
                      minPrice: _minPriceController.text,
                      maxPrice: _maxPriceController.text,
                      description: _serviceDescriptionController.text,
                      headerImage: mainImage,
                      images: listImages,
                      idAddress: _checkedAddresses.keys
                          .where((key) => _checkedAddresses[key] == true)
                          .toList(),
                    );

                    var result = await ShopApi().insertService(service);

                    if (result['isSuccess'] == true) {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.success(
                          message: 'Thêm dịch vụ thành công!',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    } else {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message: 'Thêm dịch vụ thất bại!',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                    }
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
                child: Column(children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ảnh đại diện: (*)',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: mainImage == null || mainImage?.path == ''
                          ? const Center(
                              child: Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.file(
                                File(mainImage!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Các ảnh mô tả (tối đa 4 hình):',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            // ignore: prefer_is_empty
                            child: listImages.length < 1 ||
                                    listImages[0]?.path == ''
                                ? const Center(
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.file(
                                      File(listImages[0]!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: listImages.length < 2
                                ? const Center(
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.file(
                                      File(listImages[1]!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: listImages.length < 3
                                ? const Center(
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.file(
                                      File(listImages[2]!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: listImages.length < 4
                                ? const Center(
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.file(
                                      File(listImages[3]!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _addImage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Thêm ảnh',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _deleteImage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Xóa ảnh',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  InfoInputField(
                    label: 'Tên dịch vụ: (*)',
                    hintText: '',
                    controller: _serviceNameController,
                  ),
                  const SizedBox(height: 20.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Loại dịch vụ: (*)',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButtonFormField<int>(
                    value: selectedServiceType,
                    onChanged: (newValue) {
                      setState(() {
                        selectedServiceType = newValue!;
                        serviceTypeDetails = serviceTypes
                            .firstWhere((element) =>
                                element.idServiceType == selectedServiceType)
                            .details
                            .toList()
                          ..sort((a, b) => a.idServiceTypeDetail
                              .compareTo(b.idServiceTypeDetail));
                        selectedServiceTypeDetail =
                            serviceTypeDetails[0].idServiceTypeDetail;
                      });
                    },
                    items: serviceTypes
                        .map<DropdownMenuItem<int>>((ServiceType type) {
                      return DropdownMenuItem<int>(
                        value: type.idServiceType,
                        child: Text(type.name),
                      );
                    }).toList(),
                    decoration: InputDecoration(
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
                      'Phân loại chi tiết: (*)',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButtonFormField<int>(
                    value: selectedServiceTypeDetail,
                    onChanged: (newValue) {
                      setState(() {
                        selectedServiceTypeDetail = newValue!;
                      });
                    },
                    items: serviceTypeDetails.map<DropdownMenuItem<int>>(
                        (ServiceTypeDetail serviceTypeDetail) {
                      return DropdownMenuItem<int>(
                        value: serviceTypeDetail.idServiceTypeDetail,
                        child: Text(serviceTypeDetail.name),
                      );
                    }).toList(),
                    decoration: InputDecoration(
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
                      'Mô tả: (*)',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _serviceDescriptionController,
                    cursorColor: buttonBackgroundColor,
                    maxLines: 10,
                    maxLength: maxLength,
                    decoration: InputDecoration(
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
                  InfoInputField(
                    label: 'Giá tối thiểu: (*)',
                    hintText: '',
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20.0),
                  InfoInputField(
                    label: 'Giá tối đa: (*)',
                    hintText: '',
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Khu vực cung cấp dịch vụ: (*)',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ...shopAddresses.map((address) {
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
                  const SizedBox(
                    height: 20.0,
                  ),
                ]),
              ),
            ),
          );
  }
}
