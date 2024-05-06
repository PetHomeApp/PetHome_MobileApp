import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/model/pet/model_pet_age.dart';
import 'package:pethome_mobileapp/model/pet/model_pet_detail.dart';
import 'package:pethome_mobileapp/model/pet/model_pet_in_card.dart';
import 'package:pethome_mobileapp/model/pet/model_pet_spiece.dart';
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
    var url = Uri.parse('$pethomeApiUrl/pets/$id?ratingLimit=3');

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

  Future<List<PetInCard>> searchPetsInCard(
      String keyword, int limit, int start) async {
    var url = Uri.parse(
        '$pethomeApiUrl/pets?name=$keyword&limit=$limit&start=$start');

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

  Future<List<PetSpecie>> getPetSpecies() async {
    var url = Uri.parse('$pethomeApiUrl/pet/species');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<PetSpecie> species = [];
      var data = json.decode(response.body);

      if (data == null) {
        return species;
      }

      if (data == null) {
        return species;
      }

      for (var item in data) {
        species.add(PetSpecie.fromJson(item));
      }

      return species;
    } else {
      throw Exception('Failed to load pet species');
    }
  }

  Future<List<PetAge>> getPetAges() async {
    var url = Uri.parse('$pethomeApiUrl/pet/ages');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<PetAge> ages = [];
      var data = json.decode(response.body);

      if (data == null) {
        return ages;
      }

      if (data == null) {
        return ages;
      }

      for (var item in data) {
        ages.add(PetAge.fromJson(item));
      }

      return ages;
    } else {
      throw Exception('Failed to load pet ages');
    }
  }
}
