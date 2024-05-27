class RoomInfor{
  final String idRoom;
  final String idShop;
  final String idUser;
  final String shopAvatar;
  final String shopName;
  final String userAvatar;
  final String userName;

  RoomInfor({
    required this.idRoom,
    required this.idShop,
    required this.idUser,
    required this.shopAvatar,
    required this.shopName,
    required this.userAvatar,
    required this.userName,
  });

  factory RoomInfor.fromJson(Map<String, dynamic> json) {
    return RoomInfor(
      idRoom: json['id_room'],
      idShop: json['id_shop'],
      idUser: json['id_user'],
      shopAvatar: json['shop_avatar'],
      shopName: json['shop_name'],
      userAvatar: json['user_avatar'],
      userName: json['user_name'],
    );
  }
}