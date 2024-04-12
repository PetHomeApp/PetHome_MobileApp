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
}
