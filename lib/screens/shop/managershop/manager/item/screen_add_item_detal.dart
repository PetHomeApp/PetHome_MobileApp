import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/enter_infor_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddItemDetailScreen extends StatefulWidget {
  const AddItemDetailScreen(
      {super.key, required this.itemID, required this.itemName});
  final String itemID;
  final String itemName;

  @override
  State<AddItemDetailScreen> createState() => _AddItemDetailScreenState();
}

class _AddItemDetailScreenState extends State<AddItemDetailScreen> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

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
          "Thêm phân loại vật phẩm",
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
              if (_priceController.text.isEmpty ||
                  _sizeController.text.isEmpty ||
                  _quantityController.text.isEmpty) {
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

              if (int.parse(_priceController.text) <= 0 ||
                  int.parse(_quantityController.text) <= 0) {
                showTopSnackBar(
                  // ignore: use_build_context_synchronously
                  Overlay.of(context),
                  const CustomSnackBar.error(
                    message: 'Giá hoặc số lượng không hợp lệ!',
                  ),
                  displayDuration: const Duration(seconds: 0),
                );
                return;
              }

              var response = await ShopApi().addItemDetail(
                widget.itemID,
                int.parse(_priceController.text),
                _sizeController.text,
                int.parse(_quantityController.text),
              );

              if (response['isSuccess'] == false) {
                showTopSnackBar(
                  // ignore: use_build_context_synchronously
                  Overlay.of(context),
                  const CustomSnackBar.error(
                    message: 'Thêm vật phẩm thất bại!',
                  ),
                  displayDuration: const Duration(seconds: 0),
                );
                return;
              } else {
                showTopSnackBar(
                  // ignore: use_build_context_synchronously
                  Overlay.of(context),
                  const CustomSnackBar.success(
                    message: 'Thêm vật phẩm thành công!',
                  ),
                  displayDuration: const Duration(seconds: 0),
                );
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(true);
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.itemName,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: buttonBackgroundColor,
              ),
            ),
            const SizedBox(height: 20.0),
            InfoInputField(
              label: 'Giá: (*)',
              hintText: '',
              controller: _priceController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            InfoInputField(
              label: 'Size: (*)  Ex: S-M-L, khối lượng, Size (20x30),...',
              hintText: '',
              controller: _sizeController,
            ),
            const SizedBox(height: 20.0),
            InfoInputField(
              label: 'Số lượng: (*)',
              hintText: '',
              controller: _quantityController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
