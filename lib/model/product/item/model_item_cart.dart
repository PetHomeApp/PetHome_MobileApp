class ItemCart {
  final String idItem;
  final String idItemDetail;
  final String name;
  final String unit;
  final String shopId;
  final String shopName;
  final int price;
  final String picture;
  final String size;
  final bool inStock;
  int quantity = 1;
  bool isCheckBox = false;

  ItemCart({
    required this.idItem,
    required this.idItemDetail,
    required this.name,
    required this.unit,
    required this.price,
    required this.picture,
    required this.size,
    required this.inStock,
    required this.shopId,
    required this.shopName,
  });

  factory ItemCart.fromJson(Map<String, dynamic> json) {
    return ItemCart(
      idItem: json['id_item'],
      idItemDetail: json['id_item_detail'],
      name: json['name'],
      unit: json['unit'],
      price: json['price'],
      picture: json['picture'],
      size: json['size'],
      inStock: json['instock'],
      shopId: json['id_shop'],
      shopName: json['shop_name'],
    );
  }
}