import 'package:image_picker/image_picker.dart';

class ShopInforRegister {
  String email;
  String shopName;
  String shopAddress;
  String area;
  XFile logo;
  String taxCode;
  String bussinessType;
  String ownerName;
  String idCard;
  XFile idCardFront;
  XFile idCardBack;

  ShopInforRegister({
    required this.email,
    required this.shopName,
    required this.shopAddress,
    required this.area,
    required this.logo,
    required this.taxCode,
    required this.bussinessType,
    required this.ownerName,
    required this.idCard,
    required this.idCardFront,
    required this.idCardBack,
  });
}