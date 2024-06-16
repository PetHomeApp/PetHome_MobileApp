import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/setting/list_area.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddShopAddressScreen extends StatefulWidget {
  const AddShopAddressScreen({super.key});

  @override
  State<AddShopAddressScreen> createState() => _AddShopAddressScreenState();
}

class _AddShopAddressScreenState extends State<AddShopAddressScreen> {
final TextEditingController _addressController = TextEditingController();
  final int maxLength = 200;

  String? selectedArea = area[0];

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
          "Thêm địa chỉ chi nhánh mới",
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
              if (_addressController.text.isEmpty || selectedArea == null) {
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

              var result = await ShopApi()
                  .addAddress(_addressController.text, selectedArea!);

              if (result['isSuccess'] == true) {
                showTopSnackBar(
                  // ignore: use_build_context_synchronously
                  Overlay.of(context),
                  const CustomSnackBar.success(
                    message: 'Thêm địa chỉ thành công!',
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
                    message: 'Thêm địa chỉ thất bại!',
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
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
          child: Column(children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Địa chỉ: (*)',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _addressController,
              cursorColor: buttonBackgroundColor,
              maxLines: 3,
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
            const SizedBox(
              height: 20.0,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Khu vực: (*)',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 4.0),
            DropdownButtonFormField(
              value: selectedArea,
              items: area.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedArea = value;
                });
              },
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
          ]),
        ),
      ),
    );
  }
}