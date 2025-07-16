import 'dart:convert';
import 'package:iampelgading/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:iampelgading/features/auth/domain/entities/user.dart';
import 'package:iampelgading/features/auth/domain/repositories/auth_repository.dart';
import 'package:iampelgading/core/services/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthService authService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.authService,
  });

  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(
        username: username,
        password: password,
      );

      // Save user data to local storage
      await authService.saveUserData(
        json.encode({
          'id': userModel.id,
          'username': userModel.username,
          'email': userModel.email,
          'name': userModel.name,
        }),
      );

      // Convert model to entity
      return User(
        id: userModel.id ?? '',
        username: userModel.username ?? username,
        email: userModel.email ?? '',
        name: userModel.name ?? 'User',
      );
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await authService.logout();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userData = await authService.getUserData();
      if (userData != null && userData.isNotEmpty) {
        final userJson = json.decode(userData) as Map<String, dynamic>;
        return User(
          id: userJson['id']?.toString() ?? '',
          username: userJson['username']?.toString() ?? '',
          email: userJson['email']?.toString() ?? '',
          name: userJson['name']?.toString() ?? 'User',
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await authService.isLoggedIn();
    } catch (e) {
      return false;
    }
  }
}
