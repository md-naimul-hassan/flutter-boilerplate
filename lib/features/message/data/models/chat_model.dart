import '../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.participant,
    required super.latestMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] ?? '',
      participant: ParticipantModel.fromJson(json['participant'] ?? {}),
      latestMessage: LatestMessageModel.fromJson(json['latestMessage'] ?? {}),
    );
  }
}

class ParticipantModel extends ParticipantEntity {
  const ParticipantModel({
    required super.id,
    required super.fullName,
    required super.image,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class LatestMessageModel extends LatestMessageEntity {
  const LatestMessageModel({
    required super.id,
    required super.message,
    required super.createdAt,
  });

  factory LatestMessageModel.fromJson(Map<String, dynamic> json) {
    return LatestMessageModel(
      id: json['_id'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
