class SenderModel {
  final String id;
  final String fullName;
  final String image;

  const SenderModel({
    required this.id,
    required this.fullName,
    required this.image,
  });

  factory SenderModel.fromJson(Map<String, dynamic>? json) {
    return SenderModel(
      id: json?['_id'] ?? '',
      fullName: json?['fullName'] ?? '',
      image: json?['image'] ?? '',
    );
  }
}

class MessageModel {
  final String id;
  final String chat;
  final String message;
  final String type;
  final SenderModel sender;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  const MessageModel({
    required this.id,
    required this.chat,
    required this.message,
    required this.type,
    required this.sender,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory MessageModel.fromJson(Map<String, dynamic>? json) {
    return MessageModel(
      id: json?['_id'] ?? '',
      chat: json?['chat'] ?? '',
      message: json?['message'] ?? '',
      type: json?['type'] ?? 'general',
      sender: SenderModel.fromJson(json?['sender']),
      createdAt: DateTime.tryParse(json?['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json?['updatedAt'] ?? '') ?? DateTime.now(),
      version: json?['__v'] ?? 0,
    );
  }
}
