class ShopAddress {
  final String address;
  final String area;

  ShopAddress({required this.address, required this.area});

  factory ShopAddress.fromJson(Map<String, dynamic> json) {
    return ShopAddress(
      address: json['address'],
      area: json['area'],
    );
  }
}
