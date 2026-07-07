class UserModel {
  final String id;
  final String name;
  final String email;
  final String image;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    return UserModel(
      id: json?['_id'] ?? '',
      name: json?['fullName'] ?? '',
      email: json?['email'] ?? '',
      image: json?['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'_id': id, 'fullName': name, 'email': email, 'image': image};
  }

  static const empty = UserModel(
    id: '',
    name: '',
    email: '',
    image: '',
  );
}
