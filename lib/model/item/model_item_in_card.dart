class ItemInCard {
  final String idItem;
  final String imageUrl;
  final String name;
  final String shopName;
  final int minPrice;
  final List<String> areas;

  ItemInCard({
    required this.idItem,
    required this.imageUrl,
    required this.name,
    required this.shopName,
    required this.minPrice,
    required this.areas,
  });

  factory ItemInCard.fromJson(Map<String, dynamic> json) {
    return ItemInCard(
      idItem: json['id_item'],
      imageUrl: json['picture'],
      name: json['name'],
      shopName: json['shop_name'],
      minPrice: json['min_price'],
      areas: json['areas'].cast<String>(),
    );
  }
}