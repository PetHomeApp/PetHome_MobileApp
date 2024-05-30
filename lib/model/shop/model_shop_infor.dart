class ShopInfor {
  String idShop;
  String name;
  String logo;
  List<String> areas;

  ShopInfor({
    required this.idShop,
    required this.name,
    required this.logo,
    required this.areas,
  });

  factory ShopInfor.fromJson(Map<String, dynamic> json) {
    return ShopInfor(
      idShop: json['id_shop'],
      name: json['name'],
      logo: json['logo'],
      areas: List<String>.from(json['areas']),
    );
  }
}