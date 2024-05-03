import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/model/pet/model_pet_detail.dart';
import 'package:pethome_mobileapp/model/pet/model_pet_in_card.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';

class PetApi {
  Future<List<PetInCard>> getPetsInCard(int limit, int start) async {
    var url = Uri.parse('$pethomeApiUrl/pets?limit=$limit&start=$start');

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

  Future<PetDetail> getPetDetail(String id) async {
    var url = Uri.parse('$pethomeApiUrl/pets/$id');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return PetDetail.fromJson(data);
    } else {
      throw Exception('Failed to load pet detail');
    }
  }
}
