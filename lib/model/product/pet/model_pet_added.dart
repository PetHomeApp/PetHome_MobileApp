import 'package:image_picker/image_picker.dart';

class PetIsAdded {
  String name;
  String idPetSpecie;
  String idPetAge;
  String weight;
  String price;
  String description;
  XFile? headerImage;
  List<XFile?> images;

  PetIsAdded({
    required this.name,
    required this.idPetSpecie,
    required this.idPetAge,
    required this.weight,
    required this.price,
    required this.description,
    required this.headerImage,
    required this.images,
  });
}