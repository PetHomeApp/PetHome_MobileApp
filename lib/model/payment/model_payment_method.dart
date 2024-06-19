class PaymentMethod {
  final int idMethod;
  final String name;
  final String description;
  final String status;

  PaymentMethod({
    required this.idMethod,
    required this.name,
    required this.description,
    required this.status,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      idMethod: json['id_method'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
    );
  }
}
