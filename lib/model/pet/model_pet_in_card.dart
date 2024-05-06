class PetInCard {
  final String idPet;
  final String? name;
  final String? imageUrl;
  final String? shopName;
  final int? price;
  final int? ageID;
  final int? specieID;
  final List<String>? areas;

  PetInCard({
    required this.idPet,
    this.name,
    this.imageUrl,
    this.shopName,
    this.price,
    this.ageID,
    this.specieID,
    this.areas,
  });

  factory PetInCard.fromJson(Map<String, dynamic> json) {
    return PetInCard(
      idPet: json['id_pet'],
      name: json['name'],
      imageUrl: json['picture'],
      shopName: json['shop_name'],
      price: json['price'],
      ageID: json['age_id'],
      specieID: json['specie_id'],
      areas: json['areas'].cast<String>(),
    );
  }
}
