import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/setting/host_api.dart';

class AuthApi {
  Future<Map<String, Object?>> sendOTP(String email) async {
    try {
      var url = Uri.parse('${apiUrl}jwt/send_code');
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': email}));

      if (response.statusCode == 200) {
        String data = response.body;
        Map<String, Object?> map = json.decode(data);
        return {
          'isSuccess': true,
          'expiredAt': map['expiredAt'],
          'token': map['token'],
        };
      } else if (response.statusCode == 208) {
        return {
          'isSuccess': false,
          'message': 'Email đã tồn tại',
        };
      } else {
        return {
          'isSuccess': false,
          'message': 'Có lỗi xảy ra',
        };
      }
    } catch (e) {
      return {
        'isSuccess': false,
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, Object?>> verifyOTP(String code, String token) async {
    try {
      var url = Uri.parse('${apiUrl}jwt/verify_code');
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token,
          },
          body: json.encode({'code': code}));

      if (response.statusCode == 200) {
        String data = response.body;
        Map<String, Object?> map = json.decode(data);
        return {
          'isSuccess': true,
          'email': map['email'],
          'message': map['message'],
        };
      } else {
        String data = response.body;
        Map<String, Object?> map = json.decode(data);
        return {
          'isSuccess': false,
          'error': map['error'],
        };
      }
    } catch (e) {
      return {
        'isSuccess': false,
        'error': e.toString(),
      };
    }
  }
}
