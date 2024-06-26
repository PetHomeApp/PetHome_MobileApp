import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pethome_mobileapp/model/notification/model_notification.dart';
import 'package:pethome_mobileapp/services/api/noti_api.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationCustom> notifications = List.empty(growable: true);

  bool loading = false;
  int _currentPageNotifier = 0;
  final ScrollController _scrollController = ScrollController();

  int numNotRead = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listenerScroll);
    _getNotification();
  }

  _getNotification() async {
    if (loading) {
      return;
    }

    loading = true;
    var dataResponse =
        await NotificationApi().getNotification(_currentPageNotifier * 10, 10);

    if (dataResponse['isSuccess'] == true) {
      List<NotificationCustom> listNoti = dataResponse['notifications'];

      setState(() {
        for (var noti in listNoti) {
          if (!noti.isRead) {
            numNotRead++;
          }
        }
        notifications.addAll(listNoti);
        _currentPageNotifier++;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  void _listenerScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        _getNotification();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          numNotRead == 0 ? "Thông báo" : "Thông báo ($numNotRead)",
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [gradientStartColor, gradientMidColor, gradientEndColor],
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check_circle_outline_rounded,
                color: iconButtonColor, size: 30),
            onPressed: () {
              List<int> notiId = [];
              for (var noti in notifications) {
                if (!noti.isRead) {
                  notiId.add(noti.idNoti);
                }
              }
              NotificationApi().updateReadNotification(notiId);
              NotificationApi().updateShowNotification(notiId);
              setState(() {
                numNotRead = 0;
                for (var element in notifications) {
                  element.isRead = true;
                }
              });
            },
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: appColor,
              ),
            )
          : notifications.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image:
                            AssetImage('lib/assets/pictures/icon_no_noti.png'),
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Không có thông báo nào',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: buttonBackgroundColor,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  controller: _scrollController,
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 3),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: notifications[index].isRead
                            ? const Color.fromARGB(219, 234, 241, 236)
                            : const Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  notifications[index].title,
                                  style: const TextStyle(
                                    color: buttonBackgroundColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${DateFormat('HH:mm').format(DateTime.parse(notifications[index].createdAt).add(const Duration(hours: 7)))}-${DateFormat('dd/MM/yyyy').format(DateTime.parse(notifications[index].createdAt).add(const Duration(hours: 7)))}',
                                  style: TextStyle(
                                    color: notifications[index].isRead
                                        ? Colors.black
                                        : const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              notifications[index].content,
                              style: TextStyle(
                                color: notifications[index].isRead
                                    ? Colors.black
                                    : const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
