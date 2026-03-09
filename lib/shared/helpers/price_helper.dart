abstract final class PriceHelper {
  static String format(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final formattedInt = _addThousandSeparator(intPart);
    return 'R\$ $formattedInt,$decPart';
  }

  static String _addThousandSeparator(String s) {
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}
