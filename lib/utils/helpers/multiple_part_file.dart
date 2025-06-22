import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;


class MultiplePartFileHelper {
  static Future<List<http.MultipartFile>> createMultipleFiles(
      List<Map<String, dynamic>> fields) async {
    List<http.MultipartFile> files = [];

    for (var field in fields) {
      var fieldName = field["fieldName"];
      var file = field["file"];

      if (file != null) {
        var multipartFile = await http.MultipartFile.fromPath(
          fieldName,
          file.path,
          filename: path.basename(file.path),
        );
        files.add(multipartFile);
      }
    }
    return files;
  }
}
