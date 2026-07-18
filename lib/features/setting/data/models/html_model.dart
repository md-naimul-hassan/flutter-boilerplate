import '../../domain/entities/html_entity.dart';

class HtmlModel extends HtmlEntity {
  const HtmlModel({required super.id, required super.content});

  factory HtmlModel.fromJson(Map<String, dynamic>? json) {
    return HtmlModel(
      id: json?['_id'] ?? '',
      content: json?['content'] ?? 'No Data Found',
    );
  }
}
