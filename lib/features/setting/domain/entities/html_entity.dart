import 'package:equatable/equatable.dart';

class HtmlEntity extends Equatable {
  const HtmlEntity({required this.id, required this.content});

  final String id;
  final String content;

  static const empty = HtmlEntity(id: '', content: '');

  @override
  List<Object?> get props => [id, content];
}
