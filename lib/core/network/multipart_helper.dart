import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

class MultipartHelper {
  static Future<FormData> build({
    List<MultipartFileItem> files = const [],
    Map<String, String> fields = const {},
  }) async {
    final formData = FormData();

    for (final file in files) {
      if (file.filePath.isEmpty || file.fileName.isEmpty) continue;

      final mimeType = lookupMimeType(file.filePath) ?? 'image/png';
      final filename = path.basename(file.filePath);
      formData.files.add(
        MapEntry(
          file.fileName,
          await MultipartFile.fromFile(
            file.filePath,
            filename: filename,
            contentType: DioMediaType.parse(mimeType),
          ),
        ),
      );
    }

    fields.forEach((key, value) {
      formData.fields.add(MapEntry(key, value));
    });

    return formData;
  }
}

class MultipartFileItem {
  final String filePath;
  final String fileName;

  const MultipartFileItem({required this.filePath, required this.fileName});
}
