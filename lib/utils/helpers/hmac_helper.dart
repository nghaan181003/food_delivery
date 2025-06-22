import 'dart:convert';
import 'package:crypto/crypto.dart';

class HmacHelper {
  static String hmacBase64Encode(String algorithm, String key, String data) {
    var keyBytes = utf8.encode(key);
    var dataBytes = utf8.encode(data);

    Hmac hmac;

    switch (algorithm.toLowerCase()) {
      case 'hmacsha256':
        hmac = Hmac(sha256, keyBytes);
        break;
      case 'hmacmd5':
        hmac = Hmac(md5, keyBytes);
        break;
      case 'hmacsha1':
        hmac = Hmac(sha1, keyBytes);
        break;
      default:
        throw UnsupportedError('Unsupported algorithm: $algorithm');
    }

    final digest = hmac.convert(dataBytes);
    return base64.encode(digest.bytes);
  }

  static String hmacHexEncode(String algorithm, String key, String data) {
    var keyBytes = utf8.encode(key);
    var dataBytes = utf8.encode(data);

    Hmac hmac;

    switch (algorithm.toLowerCase()) {
      case 'hmacsha256':
        hmac = Hmac(sha256, keyBytes);
        break;
      case 'hmacmd5':
        hmac = Hmac(md5, keyBytes);
        break;
      case 'hmacsha1':
        hmac = Hmac(sha1, keyBytes);
        break;
      default:
        throw UnsupportedError('Unsupported algorithm: $algorithm');
    }

    final digest = hmac.convert(dataBytes);
    return digest.toString(); // hex string
  }
}
