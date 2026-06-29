import 'package:flutter/material.dart';

/// NS Proxy brand palette — dark background with emerald green accents.
abstract final class AppColors {
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF0A0A0A);
  static const Color surfaceElevated = Color(0xFF141414);
  static const Color cardBorder = Color(0xFF1F2F24);

  static const Color greenLight = Color(0xFF4ADE80);
  static const Color greenPrimary = Color(0xFF22C55E);
  static const Color greenDark = Color(0xFF047857);
  static const Color greenDeep = Color(0xFF065F46);

  static const Color textPrimary = Color(0xFFF0FDF4);
  static const Color textSecondary = Color(0xFF86EFAC);
  static const Color textMuted = Color(0xFF6B7280);

  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [greenLight, greenPrimary, greenDark],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [greenLight, greenPrimary, greenDeep],
  );

  static List<BoxShadow> greenGlow({double blur = 24, double spread = 0}) => [
        BoxShadow(
          color: greenPrimary.withValues(alpha: 0.35),
          blurRadius: blur,
          spreadRadius: spread,
        ),
      ];
}
