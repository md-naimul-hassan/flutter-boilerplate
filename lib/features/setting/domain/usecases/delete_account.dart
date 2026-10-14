import '../../../../core/error/result.dart';
import '../repositories/setting_repository.dart';

class DeleteAccount {
  const DeleteAccount(this._repository);

  final SettingRepository _repository;

  Future<Result<void>> call(String password) =>
      _repository.deleteAccount(password);
}
