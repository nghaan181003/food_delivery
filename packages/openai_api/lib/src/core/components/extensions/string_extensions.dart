import 'dart:ui';

extension StringExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String get toHeaderConversation => length > 20 ? substring(0, 20) : this;

  String? extractYouTubeLink() {
    final regex = RegExp(r'https:\/\/youtu\.be\/[a-zA-Z0-9_-]+');
    final match = regex.firstMatch(this);
    return match?.group(0);
  }
}
