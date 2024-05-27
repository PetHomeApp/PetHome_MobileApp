import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/chat/room_chat_user.dart';
import 'package:pethome_mobileapp/services/api/chat_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/chat/conversation_list.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  List<ChatRoomUser> chatRoomUser = List.empty(growable: true);

  bool loading = false;

  @override
  void initState() {
    super.initState();
    getChatRoomUser();
  }

  Future<void> getChatRoomUser() async {
    if (loading) {
      return;
    }
    var dataResponse = await ChatApi().getChatRoomUser();

    if (dataResponse['isSuccess'] == true) {
      setState(() {
        chatRoomUser = dataResponse['listChatRoomUser'];
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          title: const Text(
            "Trò chuyện",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  gradientStartColor,
                  gradientMidColor,
                  gradientEndColor
                ],
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              color: Colors.white,
              child: const TabBar(
                indicatorColor: buttonBackgroundColor,
                labelColor: buttonBackgroundColor,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: 'Cá nhân'),
                  Tab(text: 'Cửa hàng'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            loading
            ? const Center(
              child: CircularProgressIndicator(
                color: appColor,
              ),
            )
            :SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ListView.builder(
                itemCount: chatRoomUser.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ConversationList(
                    idShop: chatRoomUser[index].idShop,
                    name: chatRoomUser[index].shopName,
                    messageText: chatRoomUser[index].lastMessage,
                    imageUrl: chatRoomUser[index].shopAvatar,
                    time: chatRoomUser[index].createdAt,
                    isMessageRead: chatRoomUser[index].isRead,
                  );
                },
              ),
            ),
            const Center(child: Text('Cửa hàng')),
          ],
        ),
      ),
    );
  }
}
