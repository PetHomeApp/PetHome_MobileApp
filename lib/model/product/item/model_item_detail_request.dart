class ItemDetailRequest {
  int price;
  String size;
  int quantity;

  ItemDetailRequest({
    required this.price,
    required this.size,
    required this.quantity,
  });

  @override
  String toString() {
    return '$price^$size^$quantity';
  }
}