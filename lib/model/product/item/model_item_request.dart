import 'package:image_picker/image_picker.dart';

class ItemIsRequest {
  String name;
  String idItemTypeDetail;
  String unit;
  String description;
  List<String> itemDetail;
  XFile? headerImage;
  List<XFile?> images;

  ItemIsRequest({
    required this.name,
    required this.idItemTypeDetail,
    required this.unit,
    required this.description,
    required this.itemDetail,
    required this.headerImage,
    required this.images,
  });
}
