import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  const ChatMessageEntity({
    required this.time,
    required this.text,
    required this.image,
    required this.isMe,
    this.isCall = false,
    this.isNotice = false,
  });

  final DateTime time;
  final String text;
  final String image;
  final bool isMe;
  final bool isCall;
  final bool isNotice;

  @override
  List<Object?> get props => [time, text, image, isMe, isCall, isNotice];
}
