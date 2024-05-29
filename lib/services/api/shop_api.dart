import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/model/shop/model_shop_register.dart';
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

  Future<Map<String, dynamic>> registerShop(
      ShopInforRegister shopInforRegister) async {
    var url = Uri.parse('${pethomeApiUrl}api/shop/submit');

    AuthApi authApi = AuthApi();
    var authRes = await authApi.authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    var request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = accessToken;

    request.fields['name'] = shopInforRegister.shopName;
    request.fields['address'] = shopInforRegister.shopAddress;
    request.fields['area'] = shopInforRegister.area;
    request.fields['tax_code'] = shopInforRegister.taxCode;
    request.fields['business_type'] = shopInforRegister.businessType;
    request.fields['owner_name'] = shopInforRegister.ownerName;
    request.fields['id_card'] = shopInforRegister.idCard;

    request.files.add(
      await http.MultipartFile.fromPath('logo', shopInforRegister.logo.path),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
          'front_id_card', shopInforRegister.idCardFront.path),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
          'back_id_card', shopInforRegister.idCardBack.path),
    );

    print(shopInforRegister.shopName);
    print(shopInforRegister.shopAddress);
    print(shopInforRegister.area);
    print(shopInforRegister.taxCode);
    print(shopInforRegister.businessType);
    print(shopInforRegister.ownerName);
    print(shopInforRegister.idCard);
    print(shopInforRegister.logo.path);
    print(shopInforRegister.idCardFront.path);
    print(shopInforRegister.idCardBack.path);

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        // Handle error
        var jsonResponse = json.decode(responseBody);
        print('Upload failed with status: ${response.statusCode}');
        print('Error response: $jsonResponse');
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }
}
