class ChatRoomUser {
  final String idRoom;
  final String idShop;
  final String shopName;
  final String shopAvatar;
  final bool isRead;
  final String lastMessage;
  final String createdAt;

  ChatRoomUser({
    required this.idRoom,
    required this.idShop,
    required this.shopName,
    required this.shopAvatar,
    required this.isRead,
    required this.lastMessage,
    required this.createdAt,
  });

  factory ChatRoomUser.fromJson(Map<String, dynamic> json) {
    return ChatRoomUser(
      idRoom: json['id_room'],
      idShop: json['id_shop'],
      shopName: json['shop_name'],
      shopAvatar: json['shop_avatar'],
      isRead: json['is_read_by_user'],
      lastMessage: json['last_message'],
      createdAt: json['created_at'],
    );
  }
}