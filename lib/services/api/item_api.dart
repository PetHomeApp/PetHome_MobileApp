import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/model/item/model_item_in_card.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';

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
}