import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/model/chat/room_chat_infor.dart';
import 'package:pethome_mobileapp/model/chat/room_chat_shop.dart';
import 'package:pethome_mobileapp/model/chat/room_chat_user.dart';
import 'package:pethome_mobileapp/services/api/auth_api.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatApi {
  Future<Map<String, dynamic>> getChatRoomUser() async {
    var url = Uri.parse('${chatApiUrl}api/user/rooms');

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }

        List<ChatRoomUser> listChatRoomUser = [];
        for (var item in data) {
          listChatRoomUser.add(ChatRoomUser.fromJson(item));
        }

        return {
          'isSuccess': true,
          'listChatRoomUser': listChatRoomUser,
        };
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> getChatRoomShop() async {
    var url = Uri.parse('${chatApiUrl}api/shop/rooms');

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }

        List<ChatRoomShop> listChatRoomShop = [];
        for (var item in data) {
          listChatRoomShop.add(ChatRoomShop.fromJson(item));
        }

        return {
          'isSuccess': true,
          'listChatRoomShop': listChatRoomShop,
        };
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> userJoinRoomChat(String idShop) async {
    var url = Uri.parse('${chatApiUrl}api/user/createRoom?id_shop=$idShop');

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }

        RoomInfor roomInfor = RoomInfor.fromJson(data);

        return {
          'isSuccess': true,
          'roomInfor': roomInfor,
        };
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> shopJoinRoomChat(String idUser) async {
    var url = Uri.parse('${chatApiUrl}api/shop/createRoom?id_user=$idUser');

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }

        RoomInfor roomInfor = RoomInfor.fromJson(data);

        return {
          'isSuccess': true,
          'roomInfor': roomInfor,
        };
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> checkMessageWithShop(String idshop) async {
    var url = Uri.parse('${chatApiUrl}api/user/chat/shop/$idshop');

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }

        return {
          'isSuccess': true,
          'has_messages': data['has_messages'],
        };
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }
}
