import 'package:iampelgading/features/auth/domain/entities/user.dart';
import 'package:iampelgading/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<User> call({
    required String username,
    required String password,
  }) async {
    return await repository.login(username: username, password: password);
  }
}
