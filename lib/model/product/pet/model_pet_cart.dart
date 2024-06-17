class PetCart {
  final String idPet;
  final String? name;
  final String? imageUrl;
  final String? shopName;
  final int? price;
  final int? specieID;
  final int? ageID;
  final bool inStock;
  final String? shopId;

  PetCart({
    required this.idPet,
    this.name,
    this.imageUrl,
    this.shopName,
    this.price,
    this.specieID,
    this.ageID,
    this.inStock = false,
    this.shopId,
  });

  factory PetCart.fromJson(Map<String, dynamic> json) {
    return PetCart(
      idPet: json['id_pet'],
      name: json['name'],
      imageUrl: json['picture'],
      shopName: json['shop_name'],
      price: json['price'],
      specieID: json['id_pet_specie'],
      ageID: json['id_pet_age'],
      inStock: json['instock'] ?? false,
      shopId: json['id_shop'],
    );
  }
}