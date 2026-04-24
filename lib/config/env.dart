/// VELOUR — Environment Variables
/// In a real app these would come from --dart-define or a .env file.
abstract class Env {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.velour.fashion/v1',
  );

  static const String imageBaseUrl = String.fromEnvironment(
    'IMAGE_BASE_URL',
    defaultValue: 'https://images.velour.fashion',
  );

  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_KEY',
    defaultValue: '',
  );

  static const bool isDevelopment = bool.fromEnvironment(
    'IS_DEV',
    defaultValue: true,
  );
}
