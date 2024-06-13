import 'package:pethome_mobileapp/model/product/service/model_service_type_detail.dart';

class ServiceType {
  final int idServiceType;
  final String name;
  final List<ServiceTypeDetail> details;

  ServiceType({
    required this.idServiceType,
    required this.name,
    required this.details,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
      idServiceType: json['id_service_type'],
      name: json['name'],
      details: (json['service_type_detail'] as List)
          .map((detail) => ServiceTypeDetail.fromJson(detail))
          .toList(),
    );
  }
}