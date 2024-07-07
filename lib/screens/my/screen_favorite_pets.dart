import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_cart.dart';
import 'package:pethome_mobileapp/screens/product/pet/screen_pet_detail.dart';
import 'package:pethome_mobileapp/services/api/cart_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/cart/pet_cart_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class FavoritePetsScreen extends StatefulWidget {
  const FavoritePetsScreen({super.key});

  @override
  State<FavoritePetsScreen> createState() => _FavoritePetsScreenState();
}

class _FavoritePetsScreenState extends State<FavoritePetsScreen> {
  bool loading = false;

  int countPetsCart = 0;

  List<PetCart> pets = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    getListPetsCart();
  }

  Future<void> getListPetsCart() async {
    if (loading) {
      return;
    }

    setState(() {
      loading = true;
    });
    final dataResPet = await CartApi().getListPetsCart();

    if (dataResPet['isSuccess'] == false) {
      loading = false;
      return;
    }

    setState(() {
      if (dataResPet['pets'] != null) {
        pets = dataResPet['pets'];
        countPetsCart = dataResPet['countPets'];
      } else {
        countPetsCart = 0;
      }

      loading = false;
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
              title: Text(
                "Thú cưng yêu thích ($countPetsCart)",
                style: const TextStyle(
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
            body: countPetsCart == 0
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(
                              'lib/assets/pictures/icon_empty_cart.png'),
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Thú cưng yêu thích của bạn trống',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: buttonBackgroundColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Hãy thêm thú cưng vào danh sách yêu thích của bạn',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: buttonBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ListView.builder(
                      itemCount: pets.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PetDetailScreen(
                                    idPet: pets[index].idPet,
                                    showCartIcon: false,
                                    ageID: pets[index].idPetAge)));
                          },
                          child: PetCartWidget(
                            petCart: pets[index],
                            onRemove: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Xác nhận"),
                                    content: const Text(
                                        "Bạn có chắc chắn muốn xóa thú cưng khỏi danh sách yêu thích không?"),
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
                                          var res = await CartApi()
                                              .deletePetInCart(
                                                  pets[index].idPet);

                                          if (res['isSuccess'] == true) {
                                            showTopSnackBar(
                                              // ignore: use_build_context_synchronously
                                              Overlay.of(context),
                                              const CustomSnackBar.success(
                                                message:
                                                    'Đã xóa thú cưng khỏi danh sách yêu thích',
                                              ),
                                              displayDuration:
                                                  const Duration(seconds: 0),
                                            );
                                            setState(() {
                                              pets.removeAt(index);
                                              countPetsCart--;
                                            });
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                          } else {
                                            showTopSnackBar(
                                              // ignore: use_build_context_synchronously
                                              Overlay.of(context),
                                              const CustomSnackBar.error(
                                                message:
                                                    'Đã xảy ra lỗi, vui lòng thử lại sau',
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
                          ),
                        );
                      },
                    ),
                  ),
          );
  }
}
