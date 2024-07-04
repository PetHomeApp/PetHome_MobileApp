import 'package:pethome_mobileapp/model/shop/model_shop_address.dart';

class ShopInforInProduct {
  final String name;
  final String logo;
  final List<ShopAddress> shopAddress;

  ShopInforInProduct({required this.name, required this.logo, required this.shopAddress});

  factory ShopInforInProduct.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<ShopAddress> shopAddressList =
        list.map((i) => ShopAddress.fromJson(i)).toList();

    return ShopInforInProduct(
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      shopAddress: shopAddressList,
    );
  }
}
