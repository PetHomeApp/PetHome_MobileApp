import 'package:pethome_mobileapp/model/shop/model_shop_address.dart';

class ShopInfor {
  String idShop;
  String name;
  String logo;
  List<ShopAddress> areas;

  ShopInfor({
    required this.idShop,
    required this.name,
    required this.logo,
    required this.areas,
  });

  factory ShopInfor.fromJson(Map<String, dynamic> json) {
    return ShopInfor(
      idShop: json['id_shop'],
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      areas: (json['areas'] as List)
          .map((area) => ShopAddress.fromJson(area))
          .toList(),
    );
  }
}