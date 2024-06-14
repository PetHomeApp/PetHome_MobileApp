class ShopArea {
  final String idAddress;
  final String areas;

  ShopArea({required this.idAddress, required this.areas});

  factory ShopArea.fromJson(Map<String, dynamic> json) {
    return ShopArea(
      idAddress: json['id_address'],
      areas: json['area'],
    );
  }
}