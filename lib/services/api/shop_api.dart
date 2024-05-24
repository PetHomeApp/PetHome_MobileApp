import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/services/api/auth_api.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopApi {
  Future<Map<String, dynamic>> checkIsRegisterShop() async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/check');

    AuthApi authApi = AuthApi();
    var authRes = await authApi.authorize();

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }

        if (data['message'] == 'User is shop owner') {
          return {
            'isSuccess': true,
          };
        } else {
          return {'isSuccess': false};
        }
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> checkIsActiveShop() async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/status');

    AuthApi authApi = AuthApi();
    var authRes = await authApi.authorize();

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }

        if (data['status'] == 'active') {
          return {
            'isSuccess': true,
          };
        } else {
          return {'isSuccess': false};
        }
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }
}