import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_classify.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_detail.dart';
import 'package:pethome_mobileapp/services/api/item_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/product/item/add_item_detail_sheet.dart';

class UpdateItemScreen extends StatefulWidget {
  const UpdateItemScreen({super.key, required this.idItem});

  final String idItem;

  @override
  State<UpdateItemScreen> createState() => _UpdateItemScreenState();
}

class _UpdateItemScreenState extends State<UpdateItemScreen> {
  List<DetailItemClassify> detailItemClassify = List.empty(growable: true);
  late ItemDetail itemDetail;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    getItemDetail();
  }

  Future<void> getItemDetail() async {
    if (loading) {
      return;
    }

    loading = true;
    itemDetail = await ItemApi().getItemDetail(widget.idItem);

    // ignore: unnecessary_null_comparison
    if (itemDetail == null) {
      loading = false;
      return;
    }

    if (mounted) {
      setState(() {
        itemDetail.details.sort((a, b) => a.orderItem.compareTo(b.orderItem));
        detailItemClassify = itemDetail.details;
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
                "Chỉnh sửa thông tin vật phẩm",
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
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        itemDetail.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: buttonBackgroundColor,
                        ),
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
                    ...detailItemClassify.map((item) {
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
                                  'Size: ${item.size} ${itemDetail.unit}',
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
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    //itemDetailRequest.update(item);
                                  });
                                },
                                icon: const Icon(Icons.edit,
                                    color: buttonBackgroundColor),
                              ),
                              const SizedBox(width: 10.0),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    //itemDetailRequest.remove(item);
                                  });
                                },
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
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
                  ],
                ),
              ),
            ),
          );
  }
}
