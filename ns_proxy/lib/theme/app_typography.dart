import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Central typography for NS Proxy.
abstract final class AppTypography {
  static TextStyle displayLarge({Color? color}) => GoogleFonts.exo2(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: 3,
        color: color ?? AppColors.greenPrimary,
      );

  static TextStyle displayMedium({Color? color}) => GoogleFonts.exo2(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle title({Color? color}) => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle body({Color? color, double size = 14}) => GoogleFonts.manrope(
        fontSize: size,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: color ?? AppColors.textMuted,
      );

  static TextStyle label({Color? color}) => GoogleFonts.exo2(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: color ?? AppColors.greenPrimary,
      );

  static TextStyle mono({Color? color, double size = 12}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textSecondary,
      );

  static TextStyle statValue({Color? color}) => GoogleFonts.exo2(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle button({Color? color}) => GoogleFonts.exo2(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: color ?? AppColors.background,
      );
}
