import 'package:pethome_mobileapp/model/rate/model_rate.dart';

class PetDetail {
  final String idPet;
  final String? name;
  final String? idPetSpecie;
  final int? price;
  final bool? inStock;
  final String? description;
  final String? imageUrl;
  final String? idShop;
  final List<Rate> rates;
  final double? averageRate;
  final int? totalRate;

  PetDetail(
      {required this.idPet,
      required this.name,
      required this.idPetSpecie,
      required this.price,
      required this.inStock,
      required this.description,
      required this.imageUrl,
      required this.idShop,
      required this.rates,
      required this.averageRate,
      required this.totalRate});
}