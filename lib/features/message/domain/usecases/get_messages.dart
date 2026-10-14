import '../../../../core/error/result.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/message_repository.dart';

class GetMessages {
  const GetMessages(this._repository);

  final MessageRepository _repository;

  Future<Result<List<ChatMessageEntity>>> call({
    required String chatId,
    required int page,
  }) {
    return _repository.getMessages(chatId: chatId, page: page);
  }
}
