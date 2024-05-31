class ChatRoomShop {
  final String idRoom;
  final String idUser;
  final String userName;
  final String userAvatar;
  final bool isRead;
  final String lastMessage;
  final String createdAt;

  ChatRoomShop({
    required this.idRoom,
    required this.idUser,
    required this.userName,
    required this.userAvatar,
    required this.isRead,
    required this.lastMessage,
    required this.createdAt,
  });

  factory ChatRoomShop.fromJson(Map<String, dynamic> json) {
    return ChatRoomShop(
      idRoom: json['id_room'],
      idUser: json['id_user'],
      userName: json['user_name'],
      userAvatar: json['user_avatar'],
      isRead: json['is_read_by_shop'],
      lastMessage: json['last_message'],
      createdAt: json['created_at'],
    );
  }
}