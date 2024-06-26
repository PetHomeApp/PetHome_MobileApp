import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:pethome_mobileapp/model/notification/model_notification.dart';
import 'package:pethome_mobileapp/screens/auth/screen_login.dart';
import 'package:pethome_mobileapp/screens/screen_loading.dart';
import 'package:pethome_mobileapp/screens/screen_homepage.dart';
import 'package:pethome_mobileapp/services/api/auth_api.dart';
import 'package:pethome_mobileapp/services/api/noti_api.dart';
import 'package:pethome_mobileapp/services/utils/trigger_notification.dart';
import 'package:pethome_mobileapp/setting/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: buttonBackgroundColor,
        ledColor: buttonBackgroundColor,
      )
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences sharedPreferences;
  bool isLogin = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    _initPrefs();
    startNotificationTimer();
  }

  void startNotificationTimer() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchNotifications();
    });
  }

  Future<void> fetchNotifications() async {
    var respons = await NotificationApi().getNotification(0, 1);

    if (respons['isSuccess'] == true) {
      List<NotificationCustom> notifications = respons['notifications'];

      if (notifications.isNotEmpty) {
        if (notifications[0].isShowed == false) {
          triggerNotification(notifications[0].title, notifications[0].content);
          NotificationApi().updateShowNotification([notifications[0].idNoti]);
        }
      }
    }
  }

  _initPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    //print(sharedPreferences.getString('accessToken'));
    var dataResponse = await AuthApi().authorize();

    if (dataResponse['isSuccess'] == true) {
      setState(() {
        isLoading = false;
        isLogin = true;
      });
    } else {
      setState(() {
        isLoading = false;
        isLogin = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: isLoading
          ? const LoadingScreen()
          : isLogin
              ? const MainScreen(
                  initialIndex: 0,
                )
              : const LoginScreen(),
    );
  }
}
