import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.id,
    required this.message,
    required this.linkId,
    required this.type,
    required this.role,
    required this.receiver,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String message;
  final String linkId;
  final String type;
  final String role;
  final String receiver;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
    id,
    message,
    linkId,
    type,
    role,
    receiver,
    createdAt,
    updatedAt,
  ];
}
