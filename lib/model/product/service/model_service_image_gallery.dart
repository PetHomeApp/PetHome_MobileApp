class ServiceImageGallry {
  final String idImage;
  final String url;
  final String status;
  final String createdAt;

  ServiceImageGallry({
    required this.idImage,
    required this.url,
    required this.status,
    required this.createdAt,
  });

  factory ServiceImageGallry.fromJson(Map<String, dynamic> json) {
    return ServiceImageGallry(
      idImage: json['id_image'] ?? '',
      url: json['url'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}