import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_image_gallery.dart';
import 'package:pethome_mobileapp/services/api/product/service_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class ServiceGalleryViewScreen extends StatefulWidget {
  const ServiceGalleryViewScreen({super.key, required this.idService});
  final String idService;

  @override
  State<ServiceGalleryViewScreen> createState() =>
      _ServiceGalleryViewScreenState();
}

class _ServiceGalleryViewScreenState extends State<ServiceGalleryViewScreen> {
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

    var response = await ServiceApi().getListImageGallery(widget.idService);

    if (response['isSuccess'] == true) {
      images = response['data'];
    }

    setState(() {
      loading = false;
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
          "Thư viện ảnh",
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
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      insetPadding: EdgeInsets.zero,
                                      child: GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Image.network(
                                            images[index].url,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
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
