class NotificationCustom {
  final int idNoti;
  final String title;
  final String content;
  bool isRead;
  final bool isShowed;
  final String createdAt;

  NotificationCustom({
    required this.idNoti,
    required this.title,
    required this.content,
    required this.isRead,
    required this.isShowed,
    required this.createdAt,
  });

  factory NotificationCustom.fromJson(Map<String, dynamic> json) {
    return NotificationCustom(
      idNoti: json['id_noti'],
      title: json['title'],
      content: json['message'],
      isRead: json['is_read'],
      isShowed: json['is_showed'],
      createdAt: json['created_at'],
    );
  }
}
