import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/model/pet/model_pet_in_card.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';

class PetApi {
  Future<List<PetInCard>> getPetsInCard(int limit, int start) async {
    var url = Uri.parse('$pethomeApiUrl/pets?limit=$limit&start=$start');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },);

    if (response.statusCode == 200) {
      List<PetInCard> pets = [];
      var data = json.decode(response.body);

      for (var item in data) {
        pets.add(PetInCard.fromJson(item));
      }

      return pets;
    } else {
      throw Exception('Failed to load pets');
    }
  }
}