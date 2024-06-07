import 'package:pethome_mobileapp/model/rate/model_rate.dart';

class ServiceDetail {
  final String idService;
  final String name;
  final int idServiceTypeDetail;
  final int minPrice;
  final int maxPrice;
  final String description;
  final String picture;
  final String idShop;
  final List<String> images;
  final List<String> address;
  final int totalRate;
  final double averageRate;
  final List<Rate> rates;

  ServiceDetail(
      {required this.idService,
      required this.name,
      required this.idServiceTypeDetail,
      required this.minPrice,
      required this.maxPrice,
      required this.description,
      required this.picture,
      required this.idShop,
      required this.images,
      required this.address,
      required this.totalRate,
      required this.averageRate,
      required this.rates});

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      idService: json['id_service'] as String,
      name: json['name'] as String,
      idServiceTypeDetail: json['id_service_type_detail'] as int,
      minPrice: json['min_price'] as int,
      maxPrice: json['max_price'] as int,
      description: json['description'] as String,
      picture: json['picture'] as String,
      idShop: json['id_shop'] as String,
      images: (json['images'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
      address: (json['shop']['data'] as List<dynamic>)
          .map((item) => item['address'] as String)
          .toList(),
      totalRate: json['ratings']['rating_count'] as int,
      averageRate: (json['ratings']['average_rating'] as num).toDouble(),
      rates: (json['ratings']['data'] as List<dynamic>)
          .map((item) => Rate.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}