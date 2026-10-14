import '../../../../core/error/result.dart';
import '../entities/html_entity.dart';
import '../repositories/setting_repository.dart';

class GetTermsOfServices {
  const GetTermsOfServices(this._repository);

  final SettingRepository _repository;

  Future<Result<HtmlEntity>> call() => _repository.getTermsOfServices();
}
