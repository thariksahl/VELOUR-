import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/app_data.dart';
import '../../core/services/firestore_service.dart';

class FavouritesProvider extends ChangeNotifier {
  // ── Local state ────────────────────────────────────────────────────────────

  /// Set of Firestore wishlist doc-keys that this user has wishlisted.
  /// Doc-key = product.id (non-empty) OR sanitised product name.
  final Set<String> _wishlistKeys = {};

  /// Stream subscription to the live Firestore wishlist.
  StreamSubscription<Set<String>>? _wishlistSub;

  // ── Initialise ──────────────────────────────────────────────────────────────

  FavouritesProvider() {
    _init();
  }

  Future<void> _init() async {
    // Load initial state (so UI is correct before first stream event).
    final ids = await FirestoreService.instance.loadWishlistIds();
    _wishlistKeys
      ..clear()
      ..addAll(ids);
    notifyListeners();

    // Subscribe to real-time changes.
    _wishlistSub = FirestoreService.instance.wishlistStream().listen((keys) {
      _wishlistKeys
        ..clear()
        ..addAll(keys);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _wishlistSub?.cancel();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Stable doc key for a product.
  /// Uses product.id when populated from Firestore, otherwise sanitises name.
  static String _keyFor(Product product) {
    if (product.id.isNotEmpty) return product.id;
    return product.name.replaceAll(RegExp(r'[^\w]'), '_');
  }

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  // ── Public API ─────────────────────────────────────────────────────────────

  bool isFavourited(Product product) => _wishlistKeys.contains(_keyFor(product));

  Set<String> get wishlistKeys => Set.unmodifiable(_wishlistKeys);

  /// Toggle the wishlist state for [product], updating local state immediately
  /// and persisting to Firestore asynchronously.
  void toggleFavourite(Product product) {
    if (!isLoggedIn) return;

    final key = _keyFor(product);
    final nowWishlisted = !_wishlistKeys.contains(key);

    // Optimistic local update for instant UI response.
    if (nowWishlisted) {
      _wishlistKeys.add(key);
      product.wishlisted = true;
    } else {
      _wishlistKeys.remove(key);
      product.wishlisted = false;
    }
    notifyListeners();

    // Persist to Firestore (fire-and-forget; stream will confirm).
    FirestoreService.instance.toggleWishlist(
      docKey: key,
      wishlisted: nowWishlisted,
      productName: product.name,
    );
  }

  /// Remove a specific product from the wishlist.
  void removeFavourite(Product product) {
    if (!isLoggedIn) return;

    final key = _keyFor(product);
    if (!_wishlistKeys.contains(key)) return;

    // Optimistic local update.
    _wishlistKeys.remove(key);
    product.wishlisted = false;
    notifyListeners();

    // Persist removal to Firestore.
    FirestoreService.instance.toggleWishlist(
      docKey: key,
      wishlisted: false,
      productName: product.name,
    );
  }

  /// Local list of favourited products (used as fallback / for screens
  /// that don't use the Firestore stream directly).
  List<Product> get favouritedProducts {
    return AppData.products()
        .where((p) => _wishlistKeys.contains(_keyFor(p)))
        .toList();
  }
}
