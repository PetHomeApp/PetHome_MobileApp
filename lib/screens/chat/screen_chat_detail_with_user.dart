import 'package:flutter/material.dart';

class ChatDetailWithUserScreen extends StatefulWidget {
  const ChatDetailWithUserScreen(
      {super.key,
      required this.avatar,
      required this.name,
      required this.idUser});

  final String avatar;
  final String name;
  final String idUser;


  @override
  State<ChatDetailWithUserScreen> createState() => _ChatDetailWithUserScreenState();
}

class _ChatDetailWithUserScreenState extends State<ChatDetailWithUserScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}