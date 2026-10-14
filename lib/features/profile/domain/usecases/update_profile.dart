import '../../../../core/error/result.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile {
  const UpdateProfile(this._repository);

  final ProfileRepository _repository;

  Future<Result<void>> call({
    required String fullName,
    required String phone,
    String? imagePath,
  }) {
    return _repository.updateProfile(
      fullName: fullName,
      phone: phone,
      imagePath: imagePath,
    );
  }
}
