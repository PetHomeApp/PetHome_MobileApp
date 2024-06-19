class PetCart {
  final String idPet;
  final String name;
  final int? idPetSpecie;
  final int? idPetAge;
  final int price;
  final String picture;
  final bool instock;
  final String status;
  final String idShop;
  final String shopName;

  PetCart({
    required this.idPet,
    required this.name,
    required this.idPetSpecie,
    required this.idPetAge,
    required this.price,
    required this.picture,
    required this.instock,
    required this.status,
    required this.idShop,
    required this.shopName,
  });

  factory PetCart.fromJson(Map<String, dynamic> json) {
    return PetCart(
      idPet: json['id_pet'],
      name: json['name'],
      idPetSpecie: int.parse(json['id_pet_specie']),
      idPetAge: int.parse(json['id_pet_age']),
      price: json['price'],
      picture: json['picture'],
      instock: json['instock'],
      status: json['status'],
      idShop: json['id_shop'],
      shopName: json['shop_name'],
    );
  }
}
