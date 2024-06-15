import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_detail_request.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/enter_infor_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddItemDetailSheet extends StatefulWidget {
  final Function(ItemDetailRequest) onAddItem;
  const AddItemDetailSheet({super.key, required this.onAddItem});

  @override
  State<AddItemDetailSheet> createState() => _AddItemDetailSheetState();
}

class _AddItemDetailSheetState extends State<AddItemDetailSheet> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Thêm phân loại vật phẩm',
            style: TextStyle(
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
          ElevatedButton(
            onPressed: () {
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

              ItemDetailRequest newItemDetail = ItemDetailRequest(
                price: int.parse(_priceController.text),
                size: _sizeController.text,
                quantity: int.parse(_quantityController.text),
              );

              widget.onAddItem(newItemDetail);
              Navigator.of(context).pop(true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Text(
              'Thêm',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
