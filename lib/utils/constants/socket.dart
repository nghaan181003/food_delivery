import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseUrlSocket {
  static String baseUrl = dotenv.env['SOCKET_URL'] ?? "http://localhost:8081";
}
