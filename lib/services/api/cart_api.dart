import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/model/item/model_item_cart.dart';
import 'package:pethome_mobileapp/model/pet/model_pet_cart.dart';
import 'package:pethome_mobileapp/services/api/auth_api.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartApi {
  Future<Map<String, dynamic>> getListPetsCart() async {
    var url = Uri.parse('${pethomeApiUrl}api/cart/pets');

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
        List<PetCart> pets = [];
        int count = 0;

        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }

        for (var pet in data['data']) {
          try {
            PetCart petCart = PetCart.fromJson(pet);
            pets.add(petCart);
            // ignore: empty_catches
          } catch (e) {}
        }
        count = data['count'];
        return {
          'isSuccess': true,
          'pets': pets,
          'countPets': count,
        };
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {
        'isSuccess': false,
        'message': 'Failed to load pets',
      };
    }
  }

  Future<Map<String, dynamic>> getListItemsCart() async {
    var url = Uri.parse('${pethomeApiUrl}api/cart/items');

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
        List<ItemCart> items = [];
        int count = 0;

        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }

        for (var item in data['data']) {
          try {
            ItemCart itemCart = ItemCart.fromJson(item);
            items.add(itemCart);
            // ignore: empty_catches
          } catch (e) {}
        }
        count = data['count'];

        return {
          'isSuccess': true,
          'items': items,
          'countItems': count,
        };
      } else {
        return {'isSuccess': false};
      }
    } catch (e) {
      return {
        'isSuccess': false,
        'message': 'Failed to load pets',
      };
    }
  }
}
