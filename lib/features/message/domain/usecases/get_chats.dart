import '../../../../core/error/result.dart';
import '../entities/chat_entity.dart';
import '../repositories/message_repository.dart';

class GetChats {
  const GetChats(this._repository);

  final MessageRepository _repository;

  Future<Result<List<ChatEntity>>> call(int page) => _repository.getChats(page);
}
