import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/model/product/service/model_service_detail.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_image_gallery.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_in_card.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_type.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_type_detail.dart';
import 'package:pethome_mobileapp/model/rate/model_rate.dart';
import 'package:pethome_mobileapp/services/api/auth_api.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceApi {
  Future<List<ServiceType>> getServiceType() async {
    var url = Uri.parse('${pethomeApiUrl}service/types');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<ServiceType> serviceType = [];
      var data = json.decode(response.body);

      if (data == null) {
        return serviceType;
      }

      for (var item in data) {
        serviceType.add(ServiceType.fromJson(item));
      }

      return serviceType;
    } else {
      throw Exception('Failed to load service type');
    }
  }

  Future<List<ServiceTypeDetail>> getServiceTypeDetail(
      int serviceTypeId) async {
    var url = Uri.parse('${pethomeApiUrl}service/types/$serviceTypeId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<ServiceTypeDetail> serviceTypeDetail = [];
      var data = json.decode(response.body);

      if (data == null) {
        return serviceTypeDetail;
      }

      if (data == null) {
        return serviceTypeDetail;
      }

      for (var item in data) {
        serviceTypeDetail.add(ServiceTypeDetail.fromJson(item));
      }

      return serviceTypeDetail;
    } else {
      throw Exception('Failed to load service type detail');
    }
  }

  Future<List<ServiceInCard>> getServiceInCard(
      int serviceTypeDetailId, int limit, int start) async {
    var url = Uri.parse(
        '${pethomeApiUrl}services?serviceTypeDetailID=$serviceTypeDetailId&limit=$limit&start=$start');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<ServiceInCard> serviceInCard = [];
      var data = json.decode(response.body);

      if (data == null) {
        return serviceInCard;
      }

      if (data['data'] == null) {
        return serviceInCard;
      }

      for (var item in data['data']) {
        serviceInCard.add(ServiceInCard.fromJson(item));
      }

      return serviceInCard;
    } else {
      throw Exception('Failed to load service in card');
    }
  }

  Future<ServiceDetail> getServiceDetail(String serviceId) async {
    var url = Uri.parse('${pethomeApiUrl}services/$serviceId?ratingLimit=3');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return ServiceDetail.fromJson(data);
    } else {
      throw Exception('Failed to load service detail');
    }
  }

  Future<List<ServiceInCard>> searchServicesInCard(int serviceTypeId,
      String keyword, int limit, int start, String sortRating) async {
    var url = Uri.parse(
        '${pethomeApiUrl}services?serviceTypeDetailID=$serviceTypeId&name=$keyword&limit=$limit&start=$start&ratingOrder=$sortRating');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<ServiceInCard> serviceInCard = [];
      var data = json.decode(response.body);

      if (data == null) {
        return serviceInCard;
      }

      if (data['data'] == null) {
        return serviceInCard;
      }

      for (var item in data['data']) {
        serviceInCard.add(ServiceInCard.fromJson(item));
      }

      return serviceInCard;
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<bool> checkRated(String serviceId) async {
    var url = Uri.parse('${pethomeApiUrl}api/services/$serviceId/rate');

    var authRes = await AuthApi().authorize();

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
      throw Exception('Failed to check rated service');
    }
  }

  Future<Map<String, dynamic>> sendServiceRate(
      String serviceId, int rating, String comment) async {
    var url = Uri.parse('${pethomeApiUrl}api/services/$serviceId/rate');

    var authRes = await AuthApi().authorize();

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

  Future<List<Rate>> getServiceRates(
      String idService, int limit, int start) async {
    var url = Uri.parse(
        '${pethomeApiUrl}services/$idService/ratings?limit=$limit&start=$start');

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
      throw Exception('Failed to load service rates');
    }
  }

  Future<Map<String, dynamic>> getListImageGallery(String idService) async {
    var url = Uri.parse('${pethomeApiUrl}service/$idService/gallery');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<ServiceImageGallry> images = [];
      var data = json.decode(response.body);

      if (data == null) {
        return {'isSuccess': false, 'data': images, 'count': 0};
      }

      for (var service in data) {
        images.add(ServiceImageGallry.fromJson(service));
      }
      return {'isSuccess': true, 'data': images};
    } else {
      throw Exception('Failed to load images gallery');
    }
  }
}
