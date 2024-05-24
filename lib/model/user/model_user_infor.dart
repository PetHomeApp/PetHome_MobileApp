class UserInfor {
  final String idUser;
  final String name;
  final String email;
  final String gender;
  final String phoneNum;
  final String dayOfBirth;
  final String avatar;

  UserInfor({
    required this.idUser,
    required this.name,
    required this.email,
    required this.gender,
    required this.phoneNum,
    required this.dayOfBirth,
    required this.avatar,
  });

  factory UserInfor.fromJson(Map<String, dynamic> json) {
    return UserInfor(
      idUser: json['id_user'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      phoneNum: json['phone_num'],
      dayOfBirth: json['day_of_birth'],
      avatar: json['avatar'],
    );
  }
}
