class PetInCard {
  final String idPet;
  final String? name;
  final String? imageUrl;
  final String? shopName;
  final int? price;

  PetInCard(
      {required this.idPet,
      required this.name,
      required this.imageUrl,
      required this.shopName,
      required this.price});

  factory PetInCard.fromJson(Map<String, dynamic> json) {
    return PetInCard(
      idPet: json['id_pet'],
      name: json['name'],
      imageUrl: json['picture'],
      shopName: json['shop_name'],
      price: json['price'],
    );
  }
}
