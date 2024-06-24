import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_image_gallery.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ServiceGalleryScreen extends StatefulWidget {
  const ServiceGalleryScreen({super.key, required this.serviceId});
  final String serviceId;

  @override
  State<ServiceGalleryScreen> createState() => _ServiceGalleryScreenState();
}

class _ServiceGalleryScreenState extends State<ServiceGalleryScreen> {
  List<ServiceImageGallry> images = List.empty(growable: true);

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    setState(() {
      loading = true;
    });

    var response = await ShopApi().getListImageGallery(widget.serviceId);

    if (response['isSuccess'] == true) {
      images = response['data'].where((element) => element.status == 'active').toList();
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> tempImage = await picker.pickMultiImage();

    if (tempImage.isEmpty) {
      return;
    }

    if (images.length + tempImage.length > 50) {
      showTopSnackBar(
        // ignore: use_build_context_synchronously
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Số lượng ảnh vượt quá giới hạn!',
        ),
        displayDuration: const Duration(seconds: 0),
      );
      return;
    }

    var response = await ShopApi().addImageGallery(widget.serviceId, tempImage);

    if (response['isSuccess'] == true) {
      showTopSnackBar(
        // ignore: use_build_context_synchronously
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Thêm ảnh thành công!',
        ),
        displayDuration: const Duration(seconds: 0),
      );
      images.clear();
      _fetchImages();
    } else {
      showTopSnackBar(
        // ignore: use_build_context_synchronously
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Thêm ảnh thất bại!',
        ),
        displayDuration: const Duration(seconds: 0),
      );
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
          "Thư viện ảnh dịch vụ",
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
                const Icon(Icons.add_a_photo, color: iconButtonColor, size: 30),
            onPressed: () async {
              _pickImage();
            },
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: buttonBackgroundColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
                child: Column(children: [
                  images.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Center(
                            child: Text(
                              'Không có ảnh nào!',
                              style: TextStyle(
                                color: buttonBackgroundColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                          ),
                          itemCount: images.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Xác nhận"),
                                      content: const Text(
                                          "Bạn có chắc chắn muốn xóa ảnh không?"),
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
                                            var res = await ShopApi()
                                                .deleteImageGallery(
                                                    widget.serviceId,
                                                    images[index].idImage);
                                            if (res['isSuccess']) {
                                              showTopSnackBar(
                                                // ignore: use_build_context_synchronously
                                                Overlay.of(context),
                                                const CustomSnackBar.success(
                                                  message:
                                                      'Xóa ảnh thành công!',
                                                ),
                                                displayDuration:
                                                    const Duration(seconds: 0),
                                              );
                                              setState(() {
                                                images.removeAt(index);
                                              });
                                              // ignore: use_build_context_synchronously
                                              Navigator.of(context).pop();
                                            } else {
                                              showTopSnackBar(
                                                // ignore: use_build_context_synchronously
                                                Overlay.of(context),
                                                const CustomSnackBar.error(
                                                  message:
                                                      'Đã xảy ra lỗi, vui lòng thử lại sau!',
                                                ),
                                                displayDuration:
                                                    const Duration(seconds: 0),
                                              );
                                            }
                                          },
                                          child: const Text("Xóa",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 209, 87, 78))),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Image.network(
                                images[index].url,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 20.0),
                ]),
              ),
            ),
    );
  }
}
