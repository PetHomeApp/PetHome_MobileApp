class BillItem {
  final String idBill;
  final String idShop;
  final String idUser;
  final String idItem;
  final String idItemDetail;
  final String phoneNumber;
  final String address;
  final String area;
  final int price;
  final int quantity;
  final int totalPrice;
  String status;
  final String createdAt;
  final String itemImage;
  final String itemName;
  final String itemSize;
  final String itemUnit;
  final String shopName;
  final String userName;
  final String paymentMethod;
  final String paymentStatus;

  BillItem({
    required this.idBill,
    required this.idShop,
    required this.idUser,
    required this.idItem,
    required this.idItemDetail,
    required this.phoneNumber,
    required this.address,
    required this.area,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.itemImage,
    required this.itemName,
    required this.itemSize,
    required this.itemUnit,
    required this.shopName,
    required this.userName,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      idBill: json['id_bill'],
      idShop: json['id_shop'],
      idUser: json['id_user'],
      idItem: json['id_item'],
      idItemDetail: json['id_item_detail'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      area: json['area'],
      price: json['price'],
      quantity: json['quantity'],
      totalPrice: json['total_price'],
      status: json['status'],
      createdAt: json['created_at'],
      itemImage: json['item_image'],
      itemName: json['item_name'],
      itemSize: json['item_size'],
      itemUnit: json['item_unit'],
      shopName: json['shop_name'] ?? '',
      userName: json['username'] ?? '',
      paymentMethod: json['payment_description'],
      paymentStatus: json['payment_status'] ?? '',
    );
  }
}
