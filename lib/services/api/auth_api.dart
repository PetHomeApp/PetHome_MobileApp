import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/setting/host_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  Future<Map<String, Object?>> sendOTP(String email) async {
    try {
      var url = Uri.parse('${authApiUrl}jwt/send_code');
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
          'message': 'Email đã tồn tại!',
        };
      } else {
        return {
          'isSuccess': false,
          'message': 'Có lỗi xảy ra!',
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
      var url = Uri.parse('${authApiUrl}jwt/verify_code');
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

  Future<Map<String, Object?>> register(
      String name, String email, String password) async {
    try {
      var url = Uri.parse('${authApiUrl}jwt/register');
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': name,
            'email': email,
            'password': password,
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'isSuccess': true,
        };
      } else {
        return {
          'isSuccess': false,
        };
      }
    } catch (e) {
      return {
        'isSuccess': false,
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, Object?>> login(String email, String password) async {
    try {
      var url = Uri.parse('${authApiUrl}jwt/login');
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': email,
            'password': password,
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'isSuccess': true,
          'accessToken': json.decode(response.body)['accessToken'],
          'refreshToken': json.decode(response.body)['refreshToken'],
        };
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {
        'isSuccess': false,
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, Object?>> refreshToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String refreshToken = sharedPreferences.getString('refreshToken') ?? '';

    try {
      var url = Uri.parse('${authApiUrl}refresh');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': refreshToken,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'isSuccess': true,
          'accessToken': json.decode(response.body)['accessToken'],
          'refreshToken': json.decode(response.body)['refreshToken'],
        };
      } else {
        return {
          'isSuccess': false,
        };
      }
    } catch (e) {
      return {
        'isSuccess': false,
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, Object?>> authorize() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    if (accessToken.isEmpty) {
      return {
        'isSuccess': false,
      };
    }

    try {
      var url = Uri.parse('${authApiUrl}authorize');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'isSuccess': true,
        };
      } else if (response.statusCode == 401) {
        Map<String, Object?> map = await refreshToken();

        if (map['isSuccess'] != null && map['isSuccess'] == true) {
          sharedPreferences.setString(
              'accessToken', map['accessToken'].toString());
          sharedPreferences.setString(
              'refreshToken', map['refreshToken'].toString());
          return {
            'isSuccess': true,
          };
        } else {
          return {
            'isSuccess': false,
          };
        }
      } else {
        return {
          'isSuccess': false,
        };
      }
    } catch (e) {
      return {
        'isSuccess': false,
        'message': e.toString(),
      };
    }
  }

  // Forgot password
  Future<Map<String, Object?>> sendOTPForgotPassword(String email) async {
     try {
      var url = Uri.parse('${authApiUrl}jwt/resetpass_send_code');
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
          'message': 'Email chưa tồn tại!',
        };
      } else {
        return {
          'isSuccess': false,
          'message': 'Có lỗi xảy ra!',
        };
      }
    } catch (e) {
      return {
        'isSuccess': false,
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, Object?>> verifyOTPForgotPassword(String code, String token) async {
    try {
      var url = Uri.parse('${authApiUrl}jwt/resetpass_verify_code');
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
          'token': map['token'],
          'expiredAt': map['expiredAt'],
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
