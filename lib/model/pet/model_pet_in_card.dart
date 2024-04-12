class PetInCard {
  final String idPet;
  final String? name;
  final String? imageUrl;
  final String? shopName;
  final double? price;

  PetInCard(
      {required this.idPet,
      required this.name,
      required this.imageUrl,
      required this.shopName,
      required this.price});

  factory PetInCard.fromJson(Map<String, dynamic> json) {
    return PetInCard(
      idPet: json['idPet'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      shopName: json['shopName'],
      price: json['price'],
    );
  }
}
