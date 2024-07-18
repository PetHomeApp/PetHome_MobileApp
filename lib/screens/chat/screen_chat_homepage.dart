import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/chat/room_chat_shop.dart';
import 'package:pethome_mobileapp/model/chat/room_chat_user.dart';
import 'package:pethome_mobileapp/screens/chat/screen_chat_detail_with_shop.dart';
import 'package:pethome_mobileapp/screens/chat/screen_chat_detail_with_user.dart';
import 'package:pethome_mobileapp/services/api/chat_api.dart';
import 'package:pethome_mobileapp/services/api/shop_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:pethome_mobileapp/widgets/chat/conversation_list_with_shop.dart';
import 'package:pethome_mobileapp/widgets/chat/conversation_list_with_user.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  List<ChatRoomUser> chatRoomUser = List.empty(growable: true);
  List<ChatRoomShop> chatRoomShop = List.empty(growable: true);

  bool loading = false;

  late bool isShop = false;
  late String idShop;

  @override
  void initState() {
    super.initState();
    getChatRoomUserandChatRoomShop();
  }

  Future<void> getChatRoomUserandChatRoomShop() async {
    if (loading) {
      return;
    }
    setState(() {
      loading = true;
    });

    var checkIsActiveShop = await ShopApi().checkIsActiveShop();
    var dataResponseUser = await ChatApi().getChatRoomUser();
    var dataResponseShop = await ChatApi().getChatRoomShop();

    if (dataResponseUser['isSuccess'] == true) {
      if (dataResponseShop['isSuccess'] == true) {
        if (checkIsActiveShop['isSuccess'] == true) {
          setState(() {
            isShop = true;
            idShop = checkIsActiveShop['shopId'];
            chatRoomUser = dataResponseUser['listChatRoomUser']
                .where((chat) => chat.lastMessage != '')
                .toList();
            chatRoomUser.sort((b, a) => DateTime.parse(a.createdAt)
                .compareTo(DateTime.parse(b.createdAt)));

            chatRoomShop = dataResponseShop['listChatRoomShop']
                .where((chat) => chat.lastMessage != '')
                .toList();
            chatRoomShop.sort((b, a) => DateTime.parse(a.createdAt)
                .compareTo(DateTime.parse(b.createdAt)));

            loading = false;
          });
        } else {
          setState(() {
            isShop = false;
            idShop = '';
            chatRoomUser = dataResponseUser['listChatRoomUser']
                .where((chat) => chat.lastMessage != '')
                .toList();
            chatRoomUser.sort((b, a) => DateTime.parse(a.createdAt)
                .compareTo(DateTime.parse(b.createdAt)));

            chatRoomShop = dataResponseShop['listChatRoomShop']
                .where((chat) => chat.lastMessage != '')
                .toList();
            chatRoomShop.sort((b, a) => DateTime.parse(a.createdAt)
                .compareTo(DateTime.parse(b.createdAt)));

            loading = false;
          });
        }
      } else {
        setState(() {
          isShop = false;
          idShop = '';
          chatRoomUser = dataResponseUser['listChatRoomUser']
              .where((chat) => chat.lastMessage != '')
              .toList();
          chatRoomUser.sort((b, a) => DateTime.parse(a.createdAt)
              .compareTo(DateTime.parse(b.createdAt)));

          loading = false;
        });
      }
    } else {
      setState(() {
        isShop = false;
        idShop = '';
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
        body: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: appColor,
                ),
              )
            : TabBarView(
                children: [
                  chatRoomUser.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage(
                                    'lib/assets/pictures/icon_empty_chat.png'),
                                width: 70,
                                height: 70,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Không có cuộc trò chuyện "Cá nhân" nào',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: buttonBackgroundColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: ListView.builder(
                            itemCount: chatRoomUser.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 16),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatDetailWithShopScreen(
                                        avatar: chatRoomUser[index].shopAvatar,
                                        name: chatRoomUser[index].shopName,
                                        idShop: chatRoomUser[index].idShop,
                                        isEmpty: false,
                                      ),
                                    ),
                                  ).then(
                                      (_) => getChatRoomUserandChatRoomShop());
                                },
                                child: ConversationListWithShop(
                                  idShop: chatRoomUser[index].idShop,
                                  name: chatRoomUser[index].shopName,
                                  messageText: chatRoomUser[index].lastMessage,
                                  imageUrl: chatRoomUser[index].shopAvatar,
                                  time: chatRoomUser[index].createdAt,
                                  isMessageRead: chatRoomUser[index].isRead,
                                ),
                              );
                            },
                          ),
                        ),
                  isShop == false
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage(
                                    'lib/assets/pictures/icon_not_shop.png'),
                                width: 70,
                                height: 70,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Bạn không phải là cửa hàng',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: buttonBackgroundColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      : chatRoomShop.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        'lib/assets/pictures/icon_empty_chat.png'),
                                    width: 70,
                                    height: 70,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Không có cuộc trò chuyện "Cửa hàng" nào',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: buttonBackgroundColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: ListView.builder(
                                itemCount: chatRoomShop.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 16),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChatDetailWithUserScreen(
                                                  idUser: chatRoomShop[index]
                                                      .idUser,
                                                  name: chatRoomShop[index]
                                                      .userName,
                                                  avatar: chatRoomShop[index]
                                                      .userAvatar),
                                        ),
                                      ).then((_) =>
                                          getChatRoomUserandChatRoomShop());
                                    },
                                    child: ConversationListWithUser(
                                      idUser: chatRoomShop[index].idUser,
                                      name: chatRoomShop[index].userName,
                                      messageText:
                                          chatRoomShop[index].lastMessage,
                                      imageUrl: chatRoomShop[index].userAvatar,
                                      time: chatRoomShop[index].createdAt,
                                      isMessageRead: chatRoomShop[index].isRead,
                                    ),
                                  );
                                },
                              ),
                            ),
                ],
              ),
      ),
    );
  }
}
