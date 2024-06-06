class ServiceInCard {
  final String idShop;
  final String shopName;
  final String picture;
  final String idService;
  final String serviceName;
  final int minPrice;
  final int maxPrice;
  final List<String> areas;

  ServiceInCard({
    required this.idShop,
    required this.shopName,
    required this.picture,
    required this.idService,
    required this.serviceName,
    required this.minPrice,
    required this.maxPrice,
    required this.areas,
  });

  factory ServiceInCard.fromJson(Map<String, dynamic> json) {
    return ServiceInCard(
      idShop: json['id_shop'],
      shopName: json['shop_name'],
      picture: json['picture'],
      idService: json['id_service'],
      serviceName: json['service_name'],
      minPrice: json['min_price'],
      maxPrice: json['max_price'],
      areas: List<String>.from(json['areas']),
    );
  }
}