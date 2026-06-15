abstract class RouteNames {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String productList = '/products';
  static const String explore = '/explore';
  static const String productDetail = '/products/:id';
  /// New route — passes a Product object via GoRouter `extra`.
  static const String productDetailExtra = '/product-detail';
  static const String cart = '/cart';
  static const String wishlist = '/wishlist';
  static const String profile = '/profile';
  static const String orders = '/orders';
  static const String orderConfirmation = '/order-confirmation';
  static const String notifications = '/notifications';
  static const String shippingAddress = '/profile/shipping-address';
  static const String paymentMethods = '/profile/payment-methods';
  static const String notificationSettings = '/profile/notification-settings';
  static const String language = '/profile/language';
  static const String privacyPolicy = '/profile/privacy-policy';
  static const String exploreCollectionDetail = '/explore-detail/:index';
}
