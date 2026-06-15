import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// VELOUR — Utility helpers
abstract class AppHelpers {
  // ─── Currency ──────────────────────────────────────────────────────────────
  static String formatPrice(double price, {String currency = 'USD'}) {
    // If the input is in USD, apply the conversion multiplier (280)
    final double lkrPrice = currency == 'USD' ? price * 280 : price;
    final rounded = lkrPrice.round();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    final formatted = rounded.toString().replaceAll(reg, ',');
    return 'LKR $formatted';
  }

  static String formatCompactPrice(double price) {
    // Assuming price is in LKR for compact representation, format it
    if (price >= 1000) {
      return 'LKR ${(price / 1000).toStringAsFixed(1)}k';
    }
    return 'LKR ${price.toStringAsFixed(0)}';
  }

  // ─── Date & Time ──────────────────────────────────────────────────────────
  static String formatDate(DateTime date) =>
      DateFormat('dd MMM yyyy').format(date);

  static String formatDateShort(DateTime date) =>
      DateFormat('MMM d').format(date);

  static String formatDateTime(DateTime date) =>
      DateFormat('dd MMM yyyy, HH:mm').format(date);

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 7) return formatDate(date);
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  // ─── Strings ──────────────────────────────────────────────────────────────
  static String capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}';

  static String initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  static String truncate(String text, int maxLength) =>
      text.length <= maxLength ? text : '${text.substring(0, maxLength)}...';

  // ─── Discount ─────────────────────────────────────────────────────────────
  static int discountPercent(double original, double sale) {
    if (original <= 0) return 0;
    return ((original - sale) / original * 100).round();
  }

  // ─── Snackbar ─────────────────────────────────────────────────────────────
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: isError ? Colors.red.shade800 : null,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ─── Screen ───────────────────────────────────────────────────────────────
  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  static bool isSmallScreen(BuildContext context) =>
      screenWidth(context) < 360;

  // ─── Rating ───────────────────────────────────────────────────────────────
  static String formatRating(double rating) => rating.toStringAsFixed(1);
}
