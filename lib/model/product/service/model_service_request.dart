import 'package:image_picker/image_picker.dart';

class ServiceIsRequest {
  String name;
  String idServiceDetail;
  String minPrice;
  String maxPrice;
  String description;
  XFile? headerImage;
  List<XFile?> images;
  List<String> idAddress;

  ServiceIsRequest({
    required this.name,
    required this.idServiceDetail,
    required this.minPrice,
    required this.maxPrice,
    required this.description,
    required this.headerImage,
    required this.images,
    required this.idAddress,
  });
}