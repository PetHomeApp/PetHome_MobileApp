import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/model/notification/model_notification.dart';
import 'package:pethome_mobileapp/services/api/auth_api.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationApi {
  Future<Map<String, dynamic>> getNotification(int start, int limit) async {
    var url = Uri.parse(
        '${pethomeApiUrl}api/user/notifications?limit=$limit&start=$start');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
      );

      if (response.statusCode == 200) {
        List<NotificationCustom> notifications = [];

        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }
        for (var noti in data) {
          notifications.add(NotificationCustom.fromJson(noti));
        }
        return {'isSuccess': true, 'notifications': notifications};
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> updateReadNotification(List<int> notiId) async {
    var url = Uri.parse(
        '${pethomeApiUrl}api/user/notifications/read?id=${notiId.join(',')}');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
      );

      if (response.statusCode == 200) {
        return {'isSuccess': true};
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> updateShowNotification(List<int> notiId) async {
    var url = Uri.parse(
        '${pethomeApiUrl}api/user/notifications/showed?id=${notiId.join(',')}');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
      );

      if (response.statusCode == 200) {
        return {'isSuccess': true};
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }
}
