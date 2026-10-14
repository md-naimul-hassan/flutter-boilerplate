import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  const ChatEntity({
    required this.id,
    required this.participant,
    required this.latestMessage,
  });

  final String id;
  final ParticipantEntity participant;
  final LatestMessageEntity latestMessage;

  @override
  List<Object?> get props => [id, participant, latestMessage];
}

class ParticipantEntity extends Equatable {
  const ParticipantEntity({
    required this.id,
    required this.fullName,
    required this.image,
  });

  final String id;
  final String fullName;
  final String image;

  @override
  List<Object?> get props => [id, fullName, image];
}

class LatestMessageEntity extends Equatable {
  const LatestMessageEntity({
    required this.id,
    required this.message,
    required this.createdAt,
  });

  final String id;
  final String message;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, message, createdAt];
}
