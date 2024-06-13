import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pethome_mobileapp/model/user/model_user_address.dart';
import 'package:pethome_mobileapp/screens/my/address/screen_add_address.dart';
import 'package:pethome_mobileapp/services/api/user_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ListAddressScreen extends StatefulWidget {
  const ListAddressScreen({super.key});

  @override
  State<ListAddressScreen> createState() => _ListAddressScreenState();
}

class _ListAddressScreenState extends State<ListAddressScreen> {
  List<UserAddress> addressList = List.empty(growable: true);

  bool loading = false;

  @override
  void initState() {
    super.initState();
    getUserAddress();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getUserAddress() async {
    if (loading) {
      return;
    }

    setState(() {
      loading = true;
    });

    loading = true;
    var response = await UserApi().getAddress();

    if (response['isSuccess']) {
      addressList = response['addressList'];
    } else {
      addressList = List.empty(growable: true);
      setState(() {
        loading = false;
      });
      return;
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
          "Danh sách địa chỉ",
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 30,
              color: iconButtonColor,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => const AddAddressScreen(),
              ))
                  .then((value) {
                getUserAddress();
              });
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
          : addressList.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage(
                            'lib/assets/pictures/icon_no_address.png'),
                        width: 70,
                        height: 70,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Bạn chưa thêm địa chỉ nào!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: buttonBackgroundColor,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: addressList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.3,
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Xác nhận"),
                                    content: const Text(
                                        "Bạn có chắc chắn muốn xóa địa chỉ này không?"),
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
                                          var res = await UserApi()
                                              .deleteAddress(
                                                  addressList[index].idAddress);
                                          if (res['isSuccess']) {
                                            showTopSnackBar(
                                              // ignore: use_build_context_synchronously
                                              Overlay.of(context),
                                              const CustomSnackBar.success(
                                                message:
                                                    'Xóa địa chỉ thành công!',
                                              ),
                                              displayDuration:
                                                  const Duration(seconds: 0),
                                            );
                                            setState(() {
                                              addressList.removeAt(index);
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
                            icon: Icons.delete,
                            label: "Xóa",
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Container(
                          color: Colors.grey[100],
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: SizedBox(
                              height: 120,
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Địa chỉ:  ${addressList[index].address}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                  Text(
                                    "Khu vực:  ${addressList[index].area}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: buttonBackgroundColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
