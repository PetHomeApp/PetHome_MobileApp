import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pethome_mobileapp/model/product/service/model_service_type_detail.dart';
import 'package:pethome_mobileapp/setting/host_api.dart';

class ServiceApi {
  Future<List<ServiceTypeDetail>> getServiceTypeDetail(int serviceTypeId) async {
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
}