import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/model/product/pet/model_pet_age.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_detail.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_in_card.dart';
import 'package:pethome_mobileapp/model/product/pet/model_pet_spiece.dart';
import 'package:pethome_mobileapp/model/rate/model_rate.dart';
import 'package:pethome_mobileapp/services/api/auth_api.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetApi {
  Future<List<PetInCard>> getPetsInCard(int limit, int start) async {
    var url = Uri.parse('${pethomeApiUrl}pets?limit=$limit&start=$start');

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
    var url = Uri.parse('${pethomeApiUrl}pets/$id?ratingLimit=3');

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

  Future<List<PetInCard>> searchPetsInCard(String keyword, int limit, int start,
      String sortPrice, String sortRating) async {
    var url = Uri.parse(
        '${pethomeApiUrl}pets?name=$keyword&limit=$limit&start=$start&priceOrder=$sortPrice&ratingOrder=$sortRating');

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
    var url = Uri.parse('${pethomeApiUrl}pet/species');

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
    var url = Uri.parse('${pethomeApiUrl}pet/ages');

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

  Future<bool> checkRated(String petId) async {
    var url = Uri.parse('${pethomeApiUrl}api/pets/$petId/rate');

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
      throw Exception('Failed to check rating for pet');
    }
  }

  Future<Map<String, dynamic>> sendPetRate(
      String petId, int rating, String comment) async {
    var url = Uri.parse('${pethomeApiUrl}api/pets/$petId/rate');

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

  Future<List<Rate>> getPetRates(String petId, int limit, int start) async {
    var url = Uri.parse(
        '${pethomeApiUrl}pets/$petId/ratings?limit=$limit&start=$start');

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
}
