class HtmlModel {
  final String id;
  final String content;

  const HtmlModel({required this.id, required this.content});

  factory HtmlModel.fromJson(Map<String, dynamic>? json) {
    return HtmlModel(
      id: json?['_id'] ?? '',
      content: json?['content'] ?? 'No Data Found',
    );
  }
}
