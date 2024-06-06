import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/chat/chat_message.dart';
import 'package:pethome_mobileapp/model/chat/room_chat_infor.dart';
import 'package:pethome_mobileapp/services/api/chat_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatDetailWithShopScreen extends StatefulWidget {
  const ChatDetailWithShopScreen(
      {super.key,
      required this.avatar,
      required this.name,
      required this.idShop, 
      required this.isEmpty});

  final String avatar;
  final String name;
  final String idShop;
  final bool isEmpty;

  @override
  State<ChatDetailWithShopScreen> createState() =>
      _ChatDetailWithShopScreenState();
}

class _ChatDetailWithShopScreenState extends State<ChatDetailWithShopScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  List<ChatMessage> messages = [];
  WebSocketChannel? channel;

  bool _showScrollDownButton = false;

  late String idRoom;
  late String idUser;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    getChatRoomInfor();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _showScrollDownButton = false;
      });
    } else if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _showScrollDownButton = true;
      });
    } else {
      setState(() {
        _showScrollDownButton = true;
      });
    }
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 50),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> getChatRoomInfor() async {
    ChatApi chatApi = ChatApi();
    var dataResponse = await chatApi.userJoinRoomChat(widget.idShop);
    if (dataResponse['isSuccess'] == true) {
      RoomInfor roomInfor = dataResponse['roomInfor'];
      idRoom = roomInfor.idRoom;
      idUser = roomInfor.idUser;
      var data = await joinWebSocket(idRoom, idUser);
      if (data['isSuccess'] == true) {
        setState(() {
          messages = data['messages'];
        });
        _scrollToBottom();
      }
    }
  }

  Future<Map<String, dynamic>> joinWebSocket(
      String idRoom, String idUser) async {
    var wsUrl = Uri.parse('${webSocketUrl}ws/joinRoom/$idRoom?id_user=$idUser');

    try {
      channel = WebSocketChannel.connect(wsUrl);
      List<ChatMessage> newMessages = [];

      channel!.stream.listen(
        (message) {
          var data = json.decode(message);
          ChatMessage chatMessage = ChatMessage.fromJson(data);
          setState(() {
            messages.add(chatMessage);
            _scrollToBottom();
          });
          _scrollToBottom();
        },
        onError: (error) {},
        onDone: () {},
      );

      return {
        'isSuccess': true,
        'messages': newMessages,
      };
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) {
      return;
    }

    final message = _messageController.text;

    if (channel != null) {
      channel!.sink.add(message);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Color.fromARGB(232, 255, 255, 255),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          padding: const EdgeInsets.only(left: 50, bottom: 10, right: 10),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [gradientStartColor, gradientMidColor, gradientEndColor],
            ),
          ),
          child: SafeArea(
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 45,
                  height: 45,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60.0),
                      child: Image.network(
                        widget.avatar,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset(
                              'lib/assets/pictures/placeholder_image.png',
                              fit: BoxFit.cover);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.settings,
                  color: buttonBackgroundColor,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: messages.isEmpty && widget.isEmpty
                    ? const Center(
                        child: Column(
                          children: [
                            SizedBox(height: 50),
                            Image(
                              image: AssetImage(
                                  'lib/assets/pictures/icon_empty_chat.png'),
                              width: 70,
                              height: 70,
                            ),
                            Text('Không có tin nhắn nào',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54)),
                            Text('Hãy bắt đầu trò chuyện ngay nào!',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: messages.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.only(
                                left: 14, right: 14, top: 10, bottom: 10),
                            child: Align(
                              alignment:
                                  (messages[index].messageType == "receiver"
                                      ? Alignment.topLeft
                                      : Alignment.topRight),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      (messages[index].messageType == "receiver"
                                          ? Colors.grey.shade200
                                          : gradientEndColor.withOpacity(0.5)),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  messages[index].messageContent,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: buttonBackgroundColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        cursorColor: buttonBackgroundColor,
                        controller: _messageController,
                        decoration: const InputDecoration(
                            hintText: "Nhập tin nhắn...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: buttonBackgroundColor,
                        size: 30,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: _showScrollDownButton
                    ? FloatingActionButton(
                        onPressed: _scrollToBottom,
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.arrow_downward,
                          color: buttonBackgroundColor,
                        ),
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
