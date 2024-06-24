class UserAddress {
  final String idAddress;
  final String address;
  final String area;

  UserAddress(
      {required this.idAddress, required this.address, required this.area});

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      idAddress: json['id_address'] ?? '',
      address: json['address'] ?? '',
      area: json['area'] ?? '',
    );
  }
}
