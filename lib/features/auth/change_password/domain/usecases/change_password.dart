import '../../../../../core/error/result.dart';
import '../repositories/change_password_repository.dart';

class ChangePassword {
  const ChangePassword(this._repository);

  final ChangePasswordRepository _repository;

  Future<Result<String>> call({
    required String oldPassword,
    required String newPassword,
  }) {
    return _repository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}
