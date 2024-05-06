class PetAge {
  final int id;
  final String name;

  PetAge({
    required this.id,
    required this.name,
  });

  factory PetAge.fromJson(Map<String, dynamic> json) {
    return PetAge(
      id: json['id_pet_age'],
      name: json['name'],
    );
  }
}