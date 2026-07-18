import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.message,
    required super.linkId,
    required super.type,
    required super.role,
    required super.receiver,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic>? json) {
    return NotificationModel(
      id: json?['_id'] ?? '',
      message: json?['message'] ?? '',
      linkId: json?['linkId'] ?? '',
      type: json?['type'] ?? '',
      role: json?['role'] ?? '',
      receiver: json?['receiver'] ?? '',
      createdAt: DateTime.tryParse(json?['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json?['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
