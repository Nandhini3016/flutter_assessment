class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String avatar;
  UserModel({required this.id, required this.firstName, required this.lastName, required this.avatar});

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
    id: j['id'],
    firstName: j['first_name'] ?? '',
    lastName: j['last_name'] ?? '',
    avatar: j['avatar'] ?? '',
  );

  Map<String,dynamic> toMap() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'avatar': avatar,
  };
}
