/// VELOUR — App Configuration
abstract class AppConfig {
  static const String appName = 'VELOUR';
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 1;

  // Pagination
  static const int defaultPageSize = 20;
  static const int cartMaxQuantity = 10;

  // Cache
  static const Duration cacheExpiry = Duration(hours: 24);
  static const Duration sessionTimeout = Duration(days: 30);

  // Animation durations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 500);

  // Splash
  static const Duration splashDuration = Duration(seconds: 2);
}
