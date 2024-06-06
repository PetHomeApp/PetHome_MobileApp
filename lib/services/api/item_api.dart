import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/model/product/item/model_item_detail.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_in_card.dart';
import 'package:pethome_mobileapp/model/product/item/model_item_type.dart';
import 'package:pethome_mobileapp/model/rate/model_rate.dart';
import 'package:pethome_mobileapp/services/api/auth_api.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemApi {
  Future<List<ItemInCard>> getItemsInCard(int limit, int start) async {
    var url = Uri.parse('${pethomeApiUrl}items?limit=$limit&start=$start');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<ItemInCard> items = [];
      var data = json.decode(response.body);

      if (data == null) {
        return items;
      }

      if (data['data'] == null) {
        return items;
      }

      for (var item in data['data']) {
        items.add(ItemInCard.fromJson(item));
      }

      return items;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<List<ItemInCard>> getItemsByTypeInCard(
      int detailTypeID, int limit, int start) async {
    var url = Uri.parse(
        '${pethomeApiUrl}items?detailTypeID=$detailTypeID&limit=$limit&start=$start');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<ItemInCard> items = [];
      var data = json.decode(response.body);

      if (data == null) {
        return items;
      }

      if (data['data'] == null) {
        return items;
      }

      for (var item in data['data']) {
        items.add(ItemInCard.fromJson(item));
      }

      return items;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<ItemDetail> getItemDetail(String id) async {
    var url = Uri.parse('${pethomeApiUrl}items/$id?ratingLimit=3');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return ItemDetail.fromJson(data);
    } else {
      throw Exception('Failed to load item detail');
    }
  }

  Future<List<ItemInCard>> searchItemsInCard(
      String keyword, int limit, int start) async {

    var url = Uri.parse(
        '${pethomeApiUrl}items?name=$keyword&limit=$limit&start=$start');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<ItemInCard> items = [];
      var data = json.decode(response.body);

      if (data == null) {
        return items;
      }

      if (data['data'] == null) {
        return items;
      }

      for (var item in data['data']) {
        items.add(ItemInCard.fromJson(item));
      }

      return items;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<bool> checkRated(String itemId) async {
    var url = Uri.parse('${pethomeApiUrl}api/items/$itemId/rate');

    AuthApi authApi = AuthApi();
    var authRes = await authApi.authorize();

    if (authRes['isSuccess'] == false) {
      return false;
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': accessToken,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == "rated") {
        return true;
      }
      return false;
    } else {
      throw Exception('Failed to check rating for item');
    }
  }

  Future<Map<String, dynamic>> sendItemRate(
      String itemID, int rating, String comment) async {
    var url = Uri.parse('${pethomeApiUrl}api/items/$itemID/rate');

    AuthApi authApi = AuthApi();
    var authRes = await authApi.authorize();

    if (authRes['isSuccess'] == false) {
      return {'isSuccess': false};
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString('accessToken') ?? '';

    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': accessToken,
          },
          body: jsonEncode({
            'rate': rating,
            'comment': comment,
          }));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'isSuccess': true,
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

  Future<List<Rate>> getItemRates(String itemId, int limit, int start) async {
    var url = Uri.parse(
        '${pethomeApiUrl}items/$itemId/ratings?limit=$limit&start=$start');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<Rate> rates = [];
      var data = json.decode(response.body);

      if (data == null) {
        return rates;
      }

      if (data['data'] == null) {
        return rates;
      }
      for (var item in data['data']) {
        rates.add(Rate.fromJson(item));
      }
      return rates;
    } else {
      throw Exception('Failed to load pet rates');
    }
  }

  Future<List<ItemType>> getItemTypes() async {
    var url = Uri.parse('${pethomeApiUrl}item/types');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data == null) {
        return [];
      }
      List<ItemType> itemTypes = [];

      for (var item in data) {
        itemTypes.add(ItemType.fromJson(item));
      }

      itemTypes.sort((a, b) => a.idItemType.compareTo(b.idItemType));

      return itemTypes;
    } else {
      throw Exception('Failed to load item types'); 
    }
  }
}
