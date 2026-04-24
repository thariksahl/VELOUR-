import 'package:flutter/material.dart';

/// VELOUR — Luxury Fashion Color Palette
/// Rooted in the "Earth & Paper" concept from the design system.
abstract class AppColors {
  // ─── Primary / Terracotta ──────────────────────────────────────────────────
  static const Color primary = Color(0xFF914722);
  static const Color primaryContainer = Color(0xFFAF5F38);
  static const Color primaryFixed = Color(0xFFFFDBCC);
  static const Color primaryFixedDim = Color(0xFFFFB595);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFFFBFF);

  // ─── Secondary / Warm Brown ────────────────────────────────────────────────
  static const Color secondary = Color(0xFF77574D);
  static const Color secondaryContainer = Color(0xFFFED3C7);
  static const Color secondaryFixed = Color(0xFFFFDBD0);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF795950);

  // ─── Tertiary / Gold Brown ─────────────────────────────────────────────────
  static const Color tertiary = Color(0xFF745726);
  static const Color tertiaryContainer = Color(0xFF8F6F3C);
  static const Color tertiaryFixed = Color(0xFFFFDEAE);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFFFFFBFF);

  // ─── Surface / Background ──────────────────────────────────────────────────
  static const Color surface = Color(0xFFFAF9F5);
  static const Color surfaceBright = Color(0xFFFAF9F5);
  static const Color surfaceContainer = Color(0xFFEFEEEA);
  static const Color surfaceContainerHigh = Color(0xFFE9E8E4);
  static const Color surfaceContainerHighest = Color(0xFFE3E2DF);
  static const Color surfaceContainerLow = Color(0xFFF4F4F0);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceDim = Color(0xFFDBDAD6);
  static const Color surfaceVariant = Color(0xFFE3E2DF);
  static const Color surfaceTint = Color(0xFF944A24);

  // ─── On Surface ───────────────────────────────────────────────────────────
  static const Color onSurface = Color(0xFF1B1C1A);
  static const Color onSurfaceVariant = Color(0xFF54433C);
  static const Color inverseSurface = Color(0xFF2F312E);
  static const Color inverseOnSurface = Color(0xFFF2F1ED);
  static const Color inversePrimary = Color(0xFFFFB595);

  // ─── Outline ──────────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF87736B);
  static const Color outlineVariant = Color(0xFFDAC1B8);

  // ─── Error ────────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ─── Custom Override (matches Stitch design system) ───────────────────────
  static const Color brand = Color(0xFFC06C44);
  static const Color brandSecondary = Color(0xFF5D4037);
  static const Color brandTertiary = Color(0xFFB08D57);
  static const Color brandNeutral = Color(0xFFF9F8F4);

  // ─── Gradient ─────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF1B1C1A), Color(0xFF2F312E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardOverlay = LinearGradient(
    colors: [Colors.transparent, Color(0xCC1B1C1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─── Shadows ──────────────────────────────────────────────────────────────
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: onSurface.withOpacity(0.05),
      blurRadius: 32,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: onSurface.withOpacity(0.04),
      blurRadius: 40,
      offset: const Offset(0, 12),
    ),
  ];
}
