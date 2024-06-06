class ServiceTypeDetail {
  final int idServiceTypeDetail;
  final String name;

  ServiceTypeDetail({
    required this.idServiceTypeDetail,
    required this.name,
  });

  factory ServiceTypeDetail.fromJson(Map<String, dynamic> json) {
    return ServiceTypeDetail(
      idServiceTypeDetail: json['id_service_type_detail'],
      name: json['name'],
    );
  }
}