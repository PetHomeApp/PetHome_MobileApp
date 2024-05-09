class DetailForItemType {
  final String idItemDetail;
  final String idItem;
  final String size;
  final int price;
  final int quantity;
  final bool instock;

  DetailForItemType({
    required this.idItemDetail,
    required this.idItem,
    required this.size,
    required this.price,
    required this.quantity,
    required this.instock,
  });

  factory DetailForItemType.fromJson(Map<String, dynamic> json) {
    return DetailForItemType(
      idItemDetail: json['id_item_detail'],
      idItem: json['id_item'],
      size: json['size'],
      price: json['price'],
      quantity: json['quantity'],
      instock: json['instock'],
    );
  }
}
