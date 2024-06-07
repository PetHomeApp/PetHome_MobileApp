import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_age.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_spiece.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/shop/enter_infor_widget.dart';

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

  List<PetSpecie> listPetSpecies = [
    PetSpecie(id: 1, name: 'Chó'),
    PetSpecie(id: 2, name: 'Mèo'),
    PetSpecie(id: 3, name: 'Chim'),
    PetSpecie(id: 4, name: 'Cá'),
    PetSpecie(id: 5, name: 'Rắn'),
    PetSpecie(id: 6, name: 'Khác'),
  ];

  List<PetAge> listPetAges = [
    PetAge(id: 1, name: 'Dưới 1 tháng'),
    PetAge(id: 2, name: '1 - 3 tháng'),
    PetAge(id: 3, name: '3 - 6 tháng'),
    PetAge(id: 4, name: '6 - 12 tháng'),
    PetAge(id: 5, name: '1 - 2 tuổi'),
    PetAge(id: 6, name: '2 - 3 tuổi'),
    PetAge(id: 7, name: 'Trên 3 tuổi'),
  ];

  bool loading = false;

  XFile? mainImage;

  int maxLength = 2000;

  @override
  void initState() {
    super.initState();
    getPetInformation();
    selectedSpecieId = listPetSpecies[0].id;
    selectedAgeId = listPetAges[0].id;
  }

  void getPetInformation() async {
    if (loading) {
      return;
    }
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
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: mainImage == null || mainImage?.path == ''
                          ? const Center(
                              child: Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.grey,
                                ),
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
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: mainImage == null || mainImage?.path == ''
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
                                        File(mainImage!.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: mainImage == null || mainImage?.path == ''
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
                                        File(mainImage!.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: mainImage == null || mainImage?.path == ''
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
                                        File(mainImage!.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: mainImage == null || mainImage?.path == ''
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
                                        File(mainImage!.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
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
                          width: 1.0,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: buttonBackgroundColor,
                          width: 2.0,
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
                          width: 1.0,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: buttonBackgroundColor,
                          width: 2.0,
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
                          width: 1.0,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: buttonBackgroundColor,
                          width: 2.0,
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
