import 'package:pethome_mobileapp/model/item/model_item_classify.dart';
import 'package:pethome_mobileapp/model/rate/model_rate.dart';
import 'package:pethome_mobileapp/model/shop/model_shop_infor_product.dart';

class ItemDetail {
  final String idItem;
  final String name;
  final int idItemTypeDetail;
  final String unit;
  final String description;
  final String imageUrl;
  final List<String> imageUrlDescriptions;
  final String status;
  final String idShop;
  final bool instock;
  final ShopInforInProduct shop;
  final List<DetailItemClassify> details;
  final List<Rate> rates;
  final double averageRating;
  final int totalRate;

  ItemDetail({
    required this.idItem,
    required this.name,
    required this.idItemTypeDetail,
    required this.unit,
    required this.description,
    required this.imageUrl,
    required this.imageUrlDescriptions,
    required this.status,
    required this.idShop,
    required this.instock,
    required this.shop,
    required this.details,
    required this.rates,
    required this.averageRating,
    required this.totalRate,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) {
    return ItemDetail(
      idItem: json['id_item'] as String,
      name: json['name'] as String,
      idItemTypeDetail: json['id_item_type_detail'] as int,
      unit: json['unit'] as String,
      description: json['description'] as String,
      imageUrl: json['picture'] as String,
      imageUrlDescriptions: (json['images'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
      status: json['status'] as String,
      idShop: json['id_shop'] as String,
      instock: json['instock'] as bool,
      shop: ShopInforInProduct.fromJson(json['shop'] as Map<String, dynamic>),
      details: (json['details'] as List<dynamic>)
          .map((item) =>
              DetailItemClassify.fromJson(item as Map<String, dynamic>))
          .toList(),
      rates: (json['ratings']['data'] as List<dynamic>)
          .map((item) => Rate.fromJson(item as Map<String, dynamic>))
          .toList(),
      averageRating:
          (json['ratings']['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalRate: json['ratings']['rating_count'] as int,
    );
  }
}
