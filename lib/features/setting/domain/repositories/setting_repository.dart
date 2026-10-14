import '../../../../core/error/result.dart';
import '../entities/html_entity.dart';

abstract class SettingRepository {
  Future<Result<void>> deleteAccount(String password);

  Future<Result<HtmlEntity>> getPrivacyPolicy();

  Future<Result<HtmlEntity>> getTermsOfServices();
}
