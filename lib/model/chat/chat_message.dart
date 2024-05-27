class ChatMessage {
  //"content":"Hello","id_room":"d90908a5-014b-4e9d-953c-99270ad9618e","id_sender":"0004","is_shop":true,"created_at":"2024-05-10T15:50:11.373089Z"
  final String messageContent;
  final String messageType;

  ChatMessage({required this.messageContent, required this.messageType});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageContent: json['content'],
      messageType: json['is_shop'] == true ? 'receiver' : 'sender',
    );
  }
}
