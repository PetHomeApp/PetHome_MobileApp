import 'package:pethome_mobileapp/model/product/item/model_item_type_detail.dart';

class ItemType {
  final int idItemType;
  final String name;
  final String picture;
  final List<ItemTypeDetail> itemTypeDetail;

  ItemType({
    required this.idItemType,
    required this.name,
    required this.picture,
    required this.itemTypeDetail,
  });

  factory ItemType.fromJson(Map<String, dynamic> json) {
    return ItemType(
      idItemType: json['id_item_type'],
      name: json['name'],
      picture: json['picture'],
      itemTypeDetail: (json['item_type_detail'] as List)
          .map((e) => ItemTypeDetail.fromJson(e))
          .toList(),
    );
  }
}
