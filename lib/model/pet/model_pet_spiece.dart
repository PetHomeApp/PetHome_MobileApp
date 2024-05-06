class PetSpecie {
  final int id;
  final String name;

  PetSpecie({
    required this.id,
    required this.name,
  });

  factory PetSpecie.fromJson(Map<String, dynamic> json) {
    return PetSpecie(
      id: json['id_pet_specie'],
      name: json['name'],
    );
  }
}