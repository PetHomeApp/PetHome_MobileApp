import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_detail_request.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_request.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_type.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_type_detail.dart';
import 'package:pethome_mobileapp/services/api/product/item_api.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/enter_infor_widget.dart';
import 'package:pethome_mobileapp/widgets/shop/product/item/add_item_detail_sheet.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemUnitController = TextEditingController();
  final TextEditingController _itemDescriptionController =
      TextEditingController();

  List<ItemDetailRequest> itemDetailRequest = List.empty(growable: true);

  XFile? mainImage;
  List<XFile?> listImages = List.empty(growable: true);

  List<ItemType> itemTypes = List.empty(growable: true);
  List<ItemTypeDetail> itemTypeDetails = List.empty(growable: true);

  int maxLength = 2000;

  bool loading = false;

  late int selectedItemType;
  late int selectedItemTypeDetail;

  @override
  void initState() {
    super.initState();
    getInformation();
  }

  Future<void> getInformation() async {
    if (loading) {
      return;
    }

    loading = true;

    final typeItemsDataResponse = await ItemApi().getItemTypes();

    itemTypes = typeItemsDataResponse.toList()
      ..sort((a, b) => a.idItemType.compareTo(b.idItemType));

    itemTypeDetails = itemTypes[0].itemTypeDetail.toList()
      ..sort((a, b) => a.idItemTypeDetail.compareTo(b.idItemTypeDetail));

    setState(() {
      selectedItemType = itemTypes[0].idItemType;
      selectedItemTypeDetail = itemTypeDetails[0].idItemTypeDetail;
      loading = false;
    });
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemUnitController.dispose();
    _itemDescriptionController.dispose();
    super.dispose();
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
          "Thêm vật phẩm",
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
            icon: const Icon(Icons.save, color: iconButtonColor, size: 30),
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

              if ( _itemNameController.text.isEmpty ||
                  _itemUnitController.text.isEmpty ||
                  _itemDescriptionController.text.isEmpty ||
                  itemDetailRequest.isEmpty) {
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

              if (_itemDescriptionController.text.length > maxLength) {
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

              ItemIsRequest itemIsRequest = ItemIsRequest(
                name: _itemNameController.text,
                idItemTypeDetail: selectedItemTypeDetail.toString(),
                unit: _itemUnitController.text,
                description: _itemDescriptionController.text,
                itemDetail: itemDetailRequest.map((e) => e.toString()).toList(),
                headerImage: mainImage,
                images: listImages,
              );

              var result = await ShopApi().insertItem(itemIsRequest);

              if (result['isSuccess'] == true) {
                showTopSnackBar(
                  // ignore: use_build_context_synchronously
                  Overlay.of(context),
                  const CustomSnackBar.success(
                    message: 'Thêm vật phẩm thành công!',
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
                    message: 'Thêm vật phẩm thất bại!',
                  ),
                  displayDuration: const Duration(seconds: 0),
                );
              }
            },
          ),
        ],
      ),
      body: loading
          ? const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(
                  color: buttonBackgroundColor,
                ),
              ),
            )
          : SingleChildScrollView(
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
                    label: 'Tên vật phẩm: (*)',
                    hintText: '',
                    controller: _itemNameController,
                  ),
                  const SizedBox(height: 20.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Loại vật phẩm: (*)',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButtonFormField<int>(
                    value: selectedItemType,
                    onChanged: (newValue) {
                      setState(() {
                        selectedItemType = newValue!;
                        itemTypeDetails = itemTypes
                            .firstWhere((element) =>
                                element.idItemType == selectedItemType)
                            .itemTypeDetail
                            .toList()
                          ..sort((a, b) =>
                              a.idItemTypeDetail.compareTo(b.idItemTypeDetail));
                        selectedItemTypeDetail =
                            itemTypeDetails[0].idItemTypeDetail;
                      });
                    },
                    items:
                        itemTypes.map<DropdownMenuItem<int>>((ItemType type) {
                      return DropdownMenuItem<int>(
                        value: type.idItemType,
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
                    value: selectedItemTypeDetail,
                    onChanged: (newValue) {
                      setState(() {
                        selectedItemTypeDetail = newValue!;
                      });
                    },
                    items: itemTypeDetails.map<DropdownMenuItem<int>>(
                        (ItemTypeDetail serviceTypeDetail) {
                      return DropdownMenuItem<int>(
                        value: serviceTypeDetail.idItemTypeDetail,
                        child: Text(serviceTypeDetail.name.toString().length >
                                30
                            ? '${serviceTypeDetail.name.toString().substring(0, 30)}...'
                            : serviceTypeDetail.name.toString()),
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
                  InfoInputField(
                    label: 'Đơn vị của vật phẩm: (*) (cái, túi, g, kg, size, ...)',
                    hintText: '',
                    controller: _itemUnitController,
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
                    controller: _itemDescriptionController,
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Phân loại vật phẩm: (*)',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ...itemDetailRequest.map((item) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Giá : ${NumberFormat('#,##0', 'vi').format(item.price)} VND',
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  color: priceColor,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                'Size: ${item.size} ${_itemUnitController.text}',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromARGB(255, 72, 72, 72),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                'Số lượng: ${item.quantity}',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromARGB(255, 72, 72, 72),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              itemDetailRequest.remove(item);
                            });
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: AddItemDetailSheet(
                              onAddItem: (newItemDetail) {
                                setState(() {
                                  itemDetailRequest.add(newItemDetail);
                                });
                              },
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Thêm phân loại vật phẩm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ]),
              ),
            ),
    );
  }
}
