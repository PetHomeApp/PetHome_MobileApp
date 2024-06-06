import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/model/product/service/model_service_in_card.dart';
import 'package:pethome_mobileapp/model/product/service/model_service_type_detail.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';

class ServiceApi {
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
}
