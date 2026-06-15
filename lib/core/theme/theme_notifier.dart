import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeKey = 'velour_dark_mode';

/// Persisted theme-mode notifier.
/// Listen to this with `context.watch<ThemeNotifier>().themeMode` in MaterialApp.
class ThemeNotifier extends ChangeNotifier {
  ThemeMode _mode;

  ThemeNotifier(bool isDark) : _mode = isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeMode get themeMode => _mode;

  bool get isDark => _mode == ThemeMode.dark;

  Future<void> toggle(bool value) async {
    _mode = value ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kThemeKey, value);
  }

  /// Load persisted preference — call this before [runApp].
  static Future<ThemeNotifier> load() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_kThemeKey) ?? false;
    return ThemeNotifier(isDark);
  }
}
