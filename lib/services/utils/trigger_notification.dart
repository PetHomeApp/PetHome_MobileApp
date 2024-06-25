import 'package:awesome_notifications/awesome_notifications.dart';

// ignore: non_constant_identifier_names
void TriggerNotification(String title, String content) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: title,
      body: content,
      icon: 'resource://drawable/res_app_icon',
    ),
  );
}