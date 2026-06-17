import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryClr = Color(0xFF2B1802);
  static const Color secClr = Color(0xFFDCBF85);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey700 = Color(0xFF4B5563);
  static const Color red = Color(0xFFD90429);
  static const Color white = Colors.white;
  static const Color darkBlue = Color.fromRGBO(36, 59, 77, 1.0);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  static Color primaryTxtClr([int r = 0, int g = 0, int b = 0]) =>
      const Color.fromARGB(255, 36, 59, 77);

  static Color primary([int r = 0, int g = 0, int b = 0]) =>
      Color.fromARGB(255, 255 + r, 224 + g, 130 + b);

  static Color cardShadowClr([int r = 0, int g = 0, int b = 0]) =>
      Color.fromARGB(255, 252 + r, 213 + g, 95 + b);

  static Color cardClr([int r = 0, int g = 0, int b = 0]) =>
      Color.fromARGB(255, 255 + r, 232 + g, 163 + b);

  static Color background([int r = 0, int g = 0, int b = 0]) =>
      Color.fromARGB(255, 252 + r, 213 + g, 95 + b);

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
