import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_age.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_spiece.dart';
import 'package:pethome_mobileapp/services/api/pet_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/enter_infor_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _petPriceController = TextEditingController();

  late int selectedSpecieId;
  late int selectedAgeId;

  List<PetSpecie> listPetSpecies = List.empty(growable: true);
  List<PetAge> listPetAges = List.empty(growable: true);

  bool loading = false;

  XFile? mainImage;
  List<XFile?> listImages = List.empty(growable: true);

  int maxLength = 2000;

  @override
  void initState() {
    super.initState();
    getAgeAndSpecies();
  }

  Future<void> getAgeAndSpecies() async {
    if (loading) {
      return;
    }

    loading = true;
    final ageDataResponse = await PetApi().getPetAges();
    final specieDataResponse = await PetApi().getPetSpecies();

    listPetAges = ageDataResponse;
    listPetSpecies = specieDataResponse;

    setState(() {
      selectedSpecieId = listPetSpecies[0].id;
      selectedAgeId = listPetAges[0].id;
      loading = false;
    });
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
                "Thêm thú cưng",
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
                  onPressed: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => const CartHomePageScreen(),
                    // ));
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
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
                            child: listImages.length < 1 || listImages[0]?.path == ''
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
                    label: 'Tên thú cưng: (*)',
                    hintText: '',
                    controller: _petNameController,
                  ),
                  const SizedBox(height: 20.0),
                  InfoInputField(
                    label: 'Giá (VNĐ): (*)',
                    hintText: '',
                    keyboardType: TextInputType.number,
                    controller: _petPriceController,
                  ),
                  const SizedBox(height: 20.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Loại thú cưng: (*)',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButtonFormField<int>(
                    value: selectedSpecieId,
                    onChanged: (newValue) {
                      setState(() {
                        selectedSpecieId = newValue!;
                      });
                    },
                    items: listPetSpecies
                        .map<DropdownMenuItem<int>>((PetSpecie specie) {
                      return DropdownMenuItem<int>(
                        value: specie.id,
                        child: Text(specie.name),
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
                      'Tuổi thú cưng: (*)',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButtonFormField<int>(
                    value: selectedAgeId,
                    onChanged: (newValue) {
                      setState(() {
                        selectedAgeId = newValue!;
                      });
                    },
                    items: listPetAges.map<DropdownMenuItem<int>>((PetAge age) {
                      return DropdownMenuItem<int>(
                        value: age.id,
                        child: Text(age.name),
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
                    label: 'Cân nặng (Kg): (*)',
                    hintText: '',
                    keyboardType: TextInputType.number,
                    controller: _petPriceController,
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
                    controller: _petNameController,
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
                  const SizedBox(
                    height: 20.0,
                  ),
                ]),
              ),
            ),
          );
  }
}
