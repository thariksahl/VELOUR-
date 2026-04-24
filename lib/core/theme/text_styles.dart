import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// VELOUR — Typography Scale
/// Headlines: Newsreader (serif) — editorial authority
/// Body/UI: Be Vietnam Pro (sans-serif) — clarity & modernity
abstract class AppTextStyles {
  // ─── Display ──────────────────────────────────────────────────────────────
  static TextStyle displayLarge = GoogleFonts.newsreader(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    color: AppColors.onSurface,
    height: 1.12,
  );

  static TextStyle displayMedium = GoogleFonts.newsreader(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
    height: 1.16,
  );

  static TextStyle displaySmall = GoogleFonts.newsreader(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
    height: 1.22,
  );

  // ─── Headline ─────────────────────────────────────────────────────────────
  static TextStyle headlineLarge = GoogleFonts.newsreader(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.25,
  );

  static TextStyle headlineMedium = GoogleFonts.newsreader(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface,
    height: 1.29,
  );

  static TextStyle headlineSmall = GoogleFonts.newsreader(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface,
    height: 1.33,
  );

  // ─── Title ────────────────────────────────────────────────────────────────
  static TextStyle titleLarge = GoogleFonts.beVietnamPro(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.27,
  );

  static TextStyle titleMedium = GoogleFonts.beVietnamPro(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: AppColors.onSurface,
    height: 1.50,
  );

  static TextStyle titleSmall = GoogleFonts.beVietnamPro(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: AppColors.onSurface,
    height: 1.43,
  );

  // ─── Body ─────────────────────────────────────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.beVietnamPro(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: AppColors.onSurface,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.beVietnamPro(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: AppColors.onSurface,
    height: 1.43,
  );

  static TextStyle bodySmall = GoogleFonts.beVietnamPro(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.onSurfaceVariant,
    height: 1.33,
  );

  // ─── Label ────────────────────────────────────────────────────────────────
  static TextStyle labelLarge = GoogleFonts.beVietnamPro(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: AppColors.onSurface,
    height: 1.43,
  );

  static TextStyle labelMedium = GoogleFonts.beVietnamPro(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.onSurface,
    height: 1.33,
  );

  static TextStyle labelSmall = GoogleFonts.beVietnamPro(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.onSurfaceVariant,
    height: 1.45,
  );

  // ─── Specialty ────────────────────────────────────────────────────────────
  static TextStyle brandLogo = GoogleFonts.newsreader(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: 8,
    color: AppColors.onSurface,
  );

  static TextStyle brandLogoLight = GoogleFonts.newsreader(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: 8,
    color: AppColors.surfaceContainerLowest,
  );

  static TextStyle priceTag = GoogleFonts.beVietnamPro(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 0.5,
  );

  static TextStyle priceLarge = GoogleFonts.beVietnamPro(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static TextStyle strikethrough = GoogleFonts.beVietnamPro(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.outline,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle buttonLabel = GoogleFonts.beVietnamPro(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  static TextStyle caption = GoogleFonts.beVietnamPro(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle overline = GoogleFonts.beVietnamPro(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.0,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle badgeLabel = GoogleFonts.beVietnamPro(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.onPrimary,
    letterSpacing: 0.5,
  );

  static TextStyle sectionHeading = GoogleFonts.newsreader(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    height: 1.3,
  );

  static TextStyle editorialBody = GoogleFonts.newsreader(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
    height: 1.75,
  );

  /// Convenience: copy any style with a different color
  static TextStyle colored(TextStyle base, Color color) =>
      base.copyWith(color: color);
}

/// TextTheme factory for Material 3
TextTheme buildVelourTextTheme() {
  return TextTheme(
    displayLarge: AppTextStyles.displayLarge,
    displayMedium: AppTextStyles.displayMedium,
    displaySmall: AppTextStyles.displaySmall,
    headlineLarge: AppTextStyles.headlineLarge,
    headlineMedium: AppTextStyles.headlineMedium,
    headlineSmall: AppTextStyles.headlineSmall,
    titleLarge: AppTextStyles.titleLarge,
    titleMedium: AppTextStyles.titleMedium,
    titleSmall: AppTextStyles.titleSmall,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    bodySmall: AppTextStyles.bodySmall,
    labelLarge: AppTextStyles.labelLarge,
    labelMedium: AppTextStyles.labelMedium,
    labelSmall: AppTextStyles.labelSmall,
  );
}
