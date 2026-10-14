import '../../../../core/error/result.dart';
import '../entities/html_entity.dart';
import '../repositories/setting_repository.dart';

class GetPrivacyPolicy {
  const GetPrivacyPolicy(this._repository);

  final SettingRepository _repository;

  Future<Result<HtmlEntity>> call() => _repository.getPrivacyPolicy();
}
