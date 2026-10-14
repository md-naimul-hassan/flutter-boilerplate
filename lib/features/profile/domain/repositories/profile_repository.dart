import '../../../../core/error/result.dart';

abstract class ProfileRepository {
  Future<Result<void>> updateProfile({
    required String fullName,
    required String phone,
    String? imagePath,
  });
}
