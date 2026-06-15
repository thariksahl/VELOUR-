import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'features/auth/auth_repository.dart';
import 'features/auth/auth_provider.dart';
import 'features/wishlist/favourites_provider.dart';
import 'features/cart/cart_provider.dart';
import 'features/notifications/notification_provider.dart';
import 'core/theme/theme_notifier.dart';
import 'routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/firestore_migration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // One-time migration: uploads all products to Firestore (skips if done).
  //await migrateProductsToFirestore();

  // Load persisted theme preference before the app starts.
  final themeNotifier = await ThemeNotifier.load();

  runApp(VelourApp(themeNotifier: themeNotifier));
}

class VelourApp extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  const VelourApp({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>.value(value: themeNotifier),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(AuthRepository())..init(),
        ),
        ChangeNotifierProvider<FavouritesProvider>(
          create: (_) => FavouritesProvider(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider<NotificationProvider>(
          create: (_) => NotificationProvider(),
        ),
      ],
      child: const _AppWithRouter(),
    );
  }
}

class _AppWithRouter extends StatefulWidget {
  const _AppWithRouter();

  @override
  State<_AppWithRouter> createState() => _AppWithRouterState();
}

class _AppWithRouterState extends State<_AppWithRouter> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeNotifier>().themeMode;
    return MaterialApp.router(
      title: 'VELOUR',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
    );
  }
}
