import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/model/product/pet/model_pet_in_card.dart';
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
            'shopId': data['id_shop'],
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

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        // Handle error
        json.decode(responseBody);
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<Map<String, dynamic>> getShopInfor(String shopId) async {
    var url = Uri.parse('${pethomeApiUrl}shops/$shopId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }

        return {
          'isSuccess': true,
          'shopInfor': data,
        };
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {'isSuccess': false};
    }
  }

  Future<List<PetInCard>> getListPetActiveInShop(String shopId, int limit, int start) async {
    var url = Uri.parse('${pethomeApiUrl}shops/$shopId/pets?limit=$limit&start=$start&status=active');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<PetInCard> pets = [];
      var data = json.decode(response.body);

      if (data == null) {
        return pets;
      }

      if (data['data'] == null) {
        return pets;
      }

      for (var item in data['data']) {
        pets.add(PetInCard.fromJson(item));
      }

      return pets;
    } else {
      throw Exception('Failed to load pets');
    }
  }

  Future<List<PetInCard>> getListPetRequiredInShop(String shopId, int limit, int start) async {
    var url = Uri.parse('${pethomeApiUrl}shops/$shopId/pets?limit=$limit&start=$start&status=requested');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<PetInCard> pets = [];
      var data = json.decode(response.body);

      if (data == null) {
        return pets;
      }

      if (data['data'] == null) {
        return pets;
      }

      for (var item in data['data']) {
        pets.add(PetInCard.fromJson(item));
      }

      return pets;
    } else {
      throw Exception('Failed to load pets');
    }
  }
}
