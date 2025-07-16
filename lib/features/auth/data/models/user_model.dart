import 'package:iampelgading/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({super.id, super.username, super.email, super.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      username: json['username']?.toString(),
      email: json['email']?.toString(),
      name: json['name']?.toString() ?? json['full_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username, 'email': email, 'name': name};
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      username: user.username,
      email: user.email,
      name: user.name,
    );
  }
}
