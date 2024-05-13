import 'package:pethome_mobileapp/model/rate/model_rate.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_infor_product.dart';

class PetDetail {
  final String idPet;
  final String? name;
  final int? idPetSpecie;
  final int? price;
  final bool? inStock;
  final String? description;
  final String? imageUrl;
  final List<String>? imageUrlDescriptions;
  final ShopInforInProduct? shop;
  final List<Rate> rates;
  final double? averageRate;
  final int? totalRate;

  PetDetail(
      {required this.idPet,
      required this.name,
      required this.idPetSpecie,
      required this.price,
      required this.inStock,
      required this.description,
      required this.imageUrl,
      required this.imageUrlDescriptions,
      required this.shop,
      required this.rates,
      required this.averageRate,
      required this.totalRate});

  factory PetDetail.fromJson(Map<String, dynamic> json) {
    return PetDetail(
      idPet: json['id_pet'] as String,
      name: json['name'] as String?,
      idPetSpecie: json['id_pet_Specie'],
      price: json['price'] as int?,
      inStock: json['instock'] as bool?,
      description: json['description'] as String?,
      imageUrl: json['picture'] as String?,
      imageUrlDescriptions: (json['images'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
      shop: ShopInforInProduct.fromJson(json['shop'] as Map<String, dynamic>),
      rates: (json['ratings']['data'] as List<dynamic>)
          .map((item) => Rate.fromJson(item as Map<String, dynamic>))
          .toList(),
      averageRate: (json['ratings']['average_rating'] as num?)?.toDouble(),
      totalRate: json['ratings']['rating_count'] as int?,
    );
  }
}
