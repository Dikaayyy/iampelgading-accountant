import 'package:iampelgading/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required String username, required String password});
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isLoggedIn();
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
}
