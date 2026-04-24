import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'route_names.dart';
import '../features/auth/auth_provider.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/home/home_screen.dart';
import '../features/product/explore_screen.dart';
import '../features/product/product_list_screen.dart';
import '../features/product/product_detail_screen.dart'; // BoysPantsScreen
import '../features/cart/cart_screen.dart';
import '../features/wishlist/wishlist_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/orders/orders_screen.dart';
import '../features/orders/order_confirmation_screen.dart';
import '../features/notifications/notifications_screen.dart';

class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return GoRouter(
      initialLocation: RouteNames.splash,
      debugLogDiagnostics: false,
      redirect: (context, state) {
        final isAuth = authProvider.isAuthenticated;
        final isSplash = state.matchedLocation == RouteNames.splash;
        final isAuthRoute = state.matchedLocation == RouteNames.login ||
            state.matchedLocation == RouteNames.signup;

        if (isSplash) return null;
        if (!isAuth && !isAuthRoute) return RouteNames.login;
        if (isAuth && isAuthRoute) return RouteNames.home;
        return null;
      },
      refreshListenable: authProvider,
      routes: [
        GoRoute(
          path: RouteNames.splash,
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const SplashScreen(),
          ),
        ),
        GoRoute(
          path: RouteNames.login,
          pageBuilder: (context, state) => _slideTransition(
            state,
            const LoginScreen(),
          ),
        ),
        GoRoute(
          path: RouteNames.signup,
          pageBuilder: (context, state) => _slideTransition(
            state,
            const SignupScreen(),
          ),
        ),
        GoRoute(
          path: RouteNames.home,
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const HomeScreen(),
          ),
        ),
        GoRoute(
          path: RouteNames.explore,
          pageBuilder: (context, state) => _slideTransition(
            state,
            const ExploreScreen(),
          ),
        ),
        GoRoute(
          path: RouteNames.productList,
          pageBuilder: (context, state) {
            final category = state.uri.queryParameters['category'];
            return _slideTransition(
              state,
              const MensCategoryScreen(),
            );
          },
        ),
        GoRoute(
          path: RouteNames.productDetail,
          pageBuilder: (context, state) {
            return _slideTransition(
              state,
              const ProductDetailScreen(),
            );
          },
        ),
        GoRoute(
          path: RouteNames.cart,
          pageBuilder: (context, state) => _slideTransition(
            state,
            const CartScreen(),
          ),
        ),
        GoRoute(
          path: RouteNames.wishlist,
          pageBuilder: (context, state) => _slideTransition(
            state,
            const WishlistScreen(),
          ),
        ),
        GoRoute(
          path: RouteNames.profile,
          pageBuilder: (context, state) => _slideTransition(
            state,
            const ProfileScreen(),
          ),
        ),
        GoRoute(
          path: RouteNames.orders,
          pageBuilder: (context, state) => _slideTransition(
            state,
            const OrdersScreen(),
          ),
        ),
        GoRoute(
          path: RouteNames.orderConfirmation,
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const OrderConfirmationScreen(),
          ),
        ),
        GoRoute(
          path: RouteNames.notifications,
          pageBuilder: (context, state) => _slideTransition(
            state,
            const NotificationsScreen(),
          ),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Page not found: ${state.uri}'),
        ),
      ),
    );
  }

  static CustomTransitionPage _fadeTransition(
      GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondary, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  static CustomTransitionPage _slideTransition(
      GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondary, child) {
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
