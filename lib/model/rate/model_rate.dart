class Rate {
  final String idRate;
  final String? idUser;
  final String? userName;
  final String? idProduct;
  final int? rate;
  final String? comment;
  final String? createdAt;

  Rate(
      {required this.idRate,
      required this.idUser,
      required this.userName,
      required this.idProduct,
      required this.rate,
      required this.comment,
      required this.createdAt});

  factory Rate.fromJson(Map<String, dynamic> json) {
    return Rate(
      idRate: json['id_rate'] as String,
      idUser: json['id_user'] as String?,
      userName: json['username'] as String?,
      idProduct: json['id_product'] as String?,
      rate: json['rate'] as int?,
      comment: json['comment'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}
