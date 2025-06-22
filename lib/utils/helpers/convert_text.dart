class ConvertText {
  static int getTextAsInteger(String input) {
    final text = input.replaceAll(RegExp(r'\D'), '');
    return int.tryParse(text) ?? 0;
  }
}
