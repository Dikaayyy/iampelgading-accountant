import 'package:iampelgading/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:iampelgading/features/auth/domain/entities/user.dart';
import 'package:iampelgading/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        username: username,
        password: password,
      );
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    // Implement logout logic if needed
    // Clear local storage, tokens, etc.
  }

  @override
  Future<User?> getCurrentUser() async {
    // Implement get current user logic if needed
    // Get from local storage, validate token, etc.
    return null;
  }
}
