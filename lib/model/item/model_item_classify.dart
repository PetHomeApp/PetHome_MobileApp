class DetailItemClassify {
  final String idItemDetail;
  final String idItem;
  final String size;
  final int price;
  final int quantity;
  final bool instock;
  final int orderItem;

  DetailItemClassify({
    required this.idItemDetail,
    required this.idItem,
    required this.size,
    required this.price,
    required this.quantity,
    required this.instock,
    required this.orderItem,
  });

  factory DetailItemClassify.fromJson(Map<String, dynamic> json) {
    return DetailItemClassify(
      idItemDetail: json['id_item_detail'],
      idItem: json['id_item'],
      size: json['size'],
      price: json['price'],
      quantity: json['quantity'],
      instock: json['instock'],
      orderItem: json['order_item'],
    );
  }
}
