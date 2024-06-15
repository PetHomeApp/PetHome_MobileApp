class ShopAddress {
  final String idAddress;
  final String address;
  final String area;

  ShopAddress({required this.idAddress, required this.address, required this.area});

  factory ShopAddress.fromJson(Map<String, dynamic> json) {
    return ShopAddress(
      idAddress: json['id_address'],
      address: json['address'],
      area: json['area'],
    );
  }
}
