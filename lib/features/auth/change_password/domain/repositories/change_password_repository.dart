import '../../../../../core/error/result.dart';

abstract class ChangePasswordRepository {
  Future<Result<String>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}
