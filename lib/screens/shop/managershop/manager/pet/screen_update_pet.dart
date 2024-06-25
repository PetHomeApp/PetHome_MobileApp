import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_detail.dart';
import 'package:pethome_mobileapp/services/api/product/pet_api.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/enter_infor_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UpdatePetScreen extends StatefulWidget {
  const UpdatePetScreen({super.key, required this.idPet});

  final String idPet;

  @override
  State<UpdatePetScreen> createState() => _UpdatePetScreenState();
}

enum InStock { instock, outstock }

class _UpdatePetScreenState extends State<UpdatePetScreen> {
  final TextEditingController _petPriceController = TextEditingController();
  late PetDetail petDetail;

  bool loading = false;
  InStock inStock = InStock.instock;
  String inStockString = 'Còn hàng';

  @override
  void initState() {
    super.initState();
    getPetDetail();
  }

  Future<void> getPetDetail() async {
    if (loading) {
      return;
    }

    loading = true;
    petDetail = await PetApi().getPetDetail(widget.idPet);

    // ignore: unnecessary_null_comparison
    if (petDetail == null) {
      loading = false;
      return;
    }

    if (mounted) {
      setState(() {
        _petPriceController.text = petDetail.price.toString();
        if (petDetail.inStock) {
          inStock = InStock.instock;
          inStockString = 'Còn hàng';
        } else {
          inStock = InStock.outstock;
          inStockString = 'Hết hàng';
        }
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
                "Chỉnh sửa thông tin thú cưng",
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
                    if (_petPriceController.text.isEmpty) {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message: 'Vui lòng nhập giá thú cưng',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                      return;
                    }

                    if (int.parse(_petPriceController.text) < 0) {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message: 'Giá thú cưng không hợp lệ',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                      return;
                    }

                    if (inStock == InStock.instock) {
                      inStockString = 'Còn hàng';
                    } else {
                      inStockString = 'Hết hàng';
                    }

                    if (int.parse(_petPriceController.text) ==
                            petDetail.price &&
                        (inStockString == 'Còn hàng' && petDetail.inStock ||
                            inStockString == 'Hết hàng' &&
                                !petDetail.inStock)) {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.error(
                          message: 'Không có thông tin nào thay đổi',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                      return;
                    }

                    var result = await ShopApi().updatePet(
                      widget.idPet,
                      int.parse(_petPriceController.text),
                      inStockString == 'Còn hàng' ? true : false,
                    );

                    if (result['isSuccess'] == true) {
                      showTopSnackBar(
                        // ignore: use_build_context_synchronously
                        Overlay.of(context),
                        const CustomSnackBar.success(
                          message: 'Cập nhật thông tin thú cưng thành công',
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
                          message: 'Cập nhật thông tin thú cưng thất bại',
                        ),
                        displayDuration: const Duration(seconds: 0),
                      );
                    }
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
                      petDetail.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: buttonBackgroundColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  InfoInputField(
                    label: 'Giá thú cưng: (*)',
                    hintText: '',
                    controller: _petPriceController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tình trạng thú cưng: (*)',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Radio<InStock>(
                            value: InStock.instock,
                            activeColor: buttonBackgroundColor,
                            groupValue: inStock,
                            onChanged: (InStock? value) {
                              setState(() {
                                inStock = value!;
                              });
                            },
                          ),
                          const Text('Còn hàng'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Radio<InStock>(
                            value: InStock.outstock,
                            activeColor: buttonBackgroundColor,
                            groupValue: inStock,
                            onChanged: (InStock? value) {
                              setState(() {
                                inStock = value!;
                              });
                            },
                          ),
                          const Text('Hết hàng'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
