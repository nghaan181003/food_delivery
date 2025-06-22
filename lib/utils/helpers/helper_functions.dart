class HelperFunctions {
  static String removeDiacritics(String str) {
    const withDia = 'àáâãäåèéêëìíîïòóôõöùúûüýÿ';
    const withoutDia = 'aaaaaaeeeeiiiiiooooouuuuyy';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }
}
