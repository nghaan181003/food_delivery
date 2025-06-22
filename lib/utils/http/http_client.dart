import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  static final String _baseUrl =
      dotenv.env['BASE_URL'] ?? "http://localhost:8081/api/v1";

  static Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    final uri = Uri.parse('$_baseUrl/$endpoint').replace(
      queryParameters:
          queryParams?.map((key, value) => MapEntry(key, value.toString())),
    );

    final response = await http.get(uri);

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> post(
      String endpoint, dynamic data) async {
    final url = '$_baseUrl/$endpoint';
    final encoded = json.encode(data);

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: encoded,
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> put(String endpoint,
      [dynamic data]) async {
    final url = '$_baseUrl/$endpoint';
    final encoded = data != null ? json.encode(data) : null;

    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: encoded,
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> patch(String endpoint,
      [dynamic data]) async {
    final url = '$_baseUrl/$endpoint';
    final encoded = data != null ? json.encode(data) : null;

    final response = await http.patch(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: encoded,
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final url = '$_baseUrl/$endpoint';

    final response = await http.delete(Uri.parse(url));

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> postWithFiles(
      String endpoint, dynamic fields, List<http.MultipartFile> files) async {
    final url = '$_baseUrl/$endpoint';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    fields.forEach((key, value) {
      request.fields[key] = value.toString();
    });
    request.files.addAll(files);

    var response = await request.send();
    return await _handleMultipartResponse(response);
  }

  static Future<Map<String, dynamic>> putWithFiles(
      String endpoint, dynamic fields, List<http.MultipartFile> files) async {
    final url = '$_baseUrl/$endpoint';

    var request = http.MultipartRequest('PUT', Uri.parse(url));
    fields.forEach((key, value) {
      request.fields[key] = value.toString();
    });
    request.files.addAll(files);

    var response = await request.send();
    return await _handleMultipartResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if ([200, 201, 401, 404, 409, 403].contains(response.statusCode)) {
      return json.decode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<Map<String, dynamic>> _handleMultipartResponse(
      http.StreamedResponse response) async {
    final responseBody = await response.stream.bytesToString();

    if ([200, 201].contains(response.statusCode)) {
      return json.decode(responseBody);
    } else {
      throw Exception('Error: ${response.statusCode}, $responseBody');
    }
  }
}
