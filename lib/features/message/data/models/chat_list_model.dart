class ChatModel {
  final String id;
  final Participant participant;
  final LatestMessage latestMessage;

  const ChatModel({
    required this.id,
    required this.participant,
    required this.latestMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] ?? '',
      participant: Participant.fromJson(json['participant'] ?? {}),
      latestMessage: LatestMessage.fromJson(json['latestMessage'] ?? {}),
    );
  }
}

class Participant {
  final String id;
  final String fullName;
  final String image;

  const Participant({
    required this.id,
    required this.fullName,
    required this.image,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class LatestMessage {
  final String id;
  final String message;
  final DateTime createdAt;

  const LatestMessage({
    required this.id,
    required this.message,
    required this.createdAt,
  });

  factory LatestMessage.fromJson(Map<String, dynamic> json) {
    return LatestMessage(
      id: json['_id'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
