import 'package:iampelgading/features/auth/domain/repositories/auth_repository.dart';

class ChangePasswordUsecase {
  final AuthRepository repository;

  ChangePasswordUsecase({required this.repository});

  Future<void> call({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
