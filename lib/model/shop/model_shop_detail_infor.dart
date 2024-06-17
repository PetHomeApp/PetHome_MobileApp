class ShopDetailInfor {
  final String idShop;
  final String name;
  final String logo;
  final String businessType;
  final String taxCode; 
  final String ownerName;
  final String idCard;
  final String frontIdCard;
  final String backIdCard;
  final String idUser;
  final String status;

  ShopDetailInfor({
    required this.idShop,
    required this.name,
    required this.logo,
    required this.businessType,
    required this.taxCode,
    required this.ownerName,
    required this.idCard,
    required this.frontIdCard,
    required this.backIdCard,
    required this.idUser,
    required this.status,
  });

  factory ShopDetailInfor.fromJson(Map<String, dynamic> json) {
    return ShopDetailInfor(
      idShop: json['id_shop'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      businessType: json['business_type'] ?? '',
      taxCode: json['tax_code'] ?? '',
      ownerName: json['owner_name'] ?? '',
      idCard: json['id_card'] ?? '',
      frontIdCard: json['front_id_card'] ?? '',
      backIdCard: json['back_id_card'] ?? '',
      idUser: json['id_user'] ?? '',
      status: json['status'] ?? '',
    );
  }
}