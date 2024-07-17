import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/model/product/item/model_item_cart.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_cart.dart';
import 'package:pethome_mobileapp/services/api/auth_api.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartApi {
  Future<Map<String, dynamic>> getListPetsCart() async {
    var url = Uri.parse('${pethomeApiUrl}api/cart/pets');

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
        List<PetCart> pets = [];
        int count = 0;

        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }

        if (data['data'] == null) {
          return {
            'isSuccess': true,
            'pets': pets,
            'countPets': count,
          };
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
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> getListItemsCart() async {
    var url = Uri.parse('${pethomeApiUrl}api/cart/items');

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
        List<ItemCart> items = [];
        int count = 0;

        var data = json.decode(response.body);

        if (data == null) {
          return {'isSuccess': false};
        }

        if (data['data'] == null) {
          return {
            'isSuccess': true,
            'items': items,
            'countItems': count,
          };
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

  Future<Map<String, dynamic>> addPetToCart(String petId) async {
    var url = Uri.parse('${pethomeApiUrl}api/pets/cart');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
        body: json.encode({
          'id_pet': petId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        return {
          'isSuccess': false,
          'message': 'Pet already in cart',
        };
      }
    } catch (e) {
      return {
        'isSuccess': false,
        'message': 'Failed to add pet to cart',
      };
    }
  }

  Future<Map<String, dynamic>> addItemToCart(
      String itemId, String itemDetailId) async {
    var url = Uri.parse('${pethomeApiUrl}api/items/cart');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
        body: json.encode({
          'id_item': itemId,
          'id_item_detail': itemDetailId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        return {
          'isSuccess': false,
          'message': 'Item already in cart',
        };
      }
    } catch (e) {
      return {
        'isSuccess': false,
        'message': 'Failed to add item to cart',
      };
    }
  }

  Future<Map<String, dynamic>> deletePetInCart(String petID) async {
    var url = Uri.parse('${pethomeApiUrl}api/cart/pets/$petID');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        return {
          'isSuccess': false,
          'message': 'Failed to delete pet in cart',
        };
      }
    } catch (e) {
      return {
        'isSuccess': false,
        'message': 'Failed to delete pet in cart',
      };
    }
  }

  Future<Map<String, dynamic>> deleteItemInCart(String itemDetailId) async {
    var url = Uri.parse('${pethomeApiUrl}api/cart/items/$itemDetailId');

    var authRes = await AuthApi().authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'isSuccess': true};
      } else {
        return {
          'isSuccess': false,
          'message': 'Failed to delete item in cart',
        };
      }
    } catch (e) {
      return {
        'isSuccess': false,
        'message': 'Failed to delete item in cart',
      };
    }
  }
}
