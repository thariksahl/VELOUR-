import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../data/models.dart';

/// Central Firestore data-access layer for VELOUR.
///
/// All streams are live — wrap them in [StreamBuilder] for real-time UI.
class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Helpers ───────────────────────────────────────────────────────────────

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _products =>
      _db.collection('products');

  CollectionReference<Map<String, dynamic>> _userCart(String uid) =>
      _db.collection('users').doc(uid).collection('cart');

  CollectionReference<Map<String, dynamic>> _userOrders(String uid) =>
      _db.collection('users').doc(uid).collection('orders');

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  // ── Products (Home Screen) ─────────────────────────────────────────────────

  /// Stream of all products from Firestore, ordered by name.
  Stream<List<Product>> productsStream() {
    return _products.orderBy('name').snapshots().map((snap) {
      return snap.docs.map((doc) => _productFromDoc(doc)).toList();
    });
  }

  Product _productFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Product(
      id: doc.id,
      name: d['name'] as String? ?? '',
      description: d['description'] as String? ?? '',
      price: d['price'] as String? ?? '',
      imageUrl: d['imageUrl'] as String? ?? '',
      category: d['category'] as String? ?? '',
    );
  }

  // ── Cart (Cart Screen) ────────────────────────────────────────────────────

  /// Real-time stream of the current user's cart items.
  /// Returns an empty list if not signed in.
  Stream<List<CartItem>> cartStream() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _userCart(uid).snapshots().map((snap) {
      return snap.docs.map((doc) {
        final d = doc.data();
        return CartItem(
          d['name'] as String? ?? '',
          d['variant'] as String? ?? '',
          d['price'] as String? ?? '',
          d['imageUrl'] as String? ?? '',
          qty: (d['qty'] as int?) ?? 1,
        );
      }).toList();
    });
  }

  /// Add an item to the current user's Firestore cart.
  Future<void> addToCart(CartItem item) async {
    final uid = _uid;
    if (uid == null) return;
    // Use name+variant as a deterministic ID to prevent duplicates.
    final docId = '${item.name}__${item.variant}'.replaceAll(RegExp(r'[^\w]'), '_');
    final ref = _userCart(uid).doc(docId);
    final snap = await ref.get();
    if (snap.exists) {
      // Increment qty if already present
      await ref.update({'qty': FieldValue.increment(1)});
    } else {
      await ref.set({
        'name': item.name,
        'variant': item.variant,
        'price': item.price,
        'imageUrl': item.imageUrl,
        'qty': item.qty,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Remove a cart item by document ID (name__variant key).
  Future<void> removeFromCart(String name, String variant) async {
    final uid = _uid;
    if (uid == null) return;
    final docId = '${name}__$variant'.replaceAll(RegExp(r'[^\w]'), '_');
    await _userCart(uid).doc(docId).delete();
  }

  /// Update qty for a cart item.
  Future<void> updateCartQty(String name, String variant, int qty) async {
    final uid = _uid;
    if (uid == null) return;
    final docId = '${name}__$variant'.replaceAll(RegExp(r'[^\w]'), '_');
    if (qty <= 0) {
      await _userCart(uid).doc(docId).delete();
    } else {
      await _userCart(uid).doc(docId).update({'qty': qty});
    }
  }

  /// Clear the entire cart (called after checkout).
  Future<void> clearCart() async {
    final uid = _uid;
    if (uid == null) return;
    final snap = await _userCart(uid).get();
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // ── Orders (Orders Screen) ────────────────────────────────────────────────

  /// Real-time stream of the current user's orders, newest first.
  Stream<List<Map<String, dynamic>>> ordersStream() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _userOrders(uid)
        .orderBy('placedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  /// Place an order — snaps the current cart into an order document and clears it.
  Future<void> placeOrder(List<CartItem> cartItems, double total) async {
    final uid = _uid;
    if (uid == null) return;

    final items = cartItems
        .map((i) => {
              'name': i.name,
              'variant': i.variant,
              'price': i.price,
              'imageUrl': i.imageUrl,
              'qty': i.qty,
            })
        .toList();

    await _userOrders(uid).add({
      'items': items,
      'total': total,
      'status': 'Confirmed',
      'placedAt': FieldValue.serverTimestamp(),
    });

    await clearCart();
  }

  // ── User Profile ──────────────────────────────────────────────────────────

  /// Real-time stream of the current user's profile document.
  Stream<Map<String, dynamic>?> userProfileStream() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _userDoc(uid).snapshots().map((snap) {
      if (!snap.exists) return null;
      return snap.data();
    });
  }

  /// Create or update the user profile document.
  Future<void> upsertUserProfile({
    required String uid,
    required String email,
    String? firstName,
    String? lastName,
    String? photoUrl,
  }) async {
    await _userDoc(uid).set({
      'uid': uid,
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    debugPrint('✅ User profile upserted for $uid');
  }

  // ── Wishlist (per-user subcollection) ────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _userWishlist(String uid) =>
      _db.collection('users').doc(uid).collection('wishlist');

  /// Real-time stream of product IDs (or name-slugs) the user has wishlisted.
  /// Emits a [Set<String>] of document IDs in the wishlist subcollection.
  Stream<Set<String>> wishlistStream() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _userWishlist(uid).snapshots().map(
          (snap) => snap.docs.map((d) => d.id).toSet(),
        );
  }

  /// One-shot fetch — call on provider init to pre-populate local state.
  Future<Set<String>> loadWishlistIds() async {
    final uid = _uid;
    if (uid == null) return {};
    final snap = await _userWishlist(uid).get();
    return snap.docs.map((d) => d.id).toSet();
  }

  /// Add or remove a product from the user's Firestore wishlist.
  /// [docKey] is the stable key used as the Firestore document ID
  /// (prefer product.id when available, fall back to sanitised name).
  Future<void> toggleWishlist({
    required String docKey,
    required bool wishlisted,
    String? productName,
  }) async {
    final uid = _uid;
    if (uid == null) return;
    final ref = _userWishlist(uid).doc(docKey);
    if (wishlisted) {
      await ref.set({
        'wishlisted': true,
        'productId': docKey,
        if (productName != null) 'name': productName,
        'addedAt': FieldValue.serverTimestamp(),
      });
      // ✅ Also update wishlisted field in the products collection
      try {
        await _products.doc(docKey).update({'wishlisted': true});
      } catch (_) {}
    } else {
      await ref.delete();
      // ✅ Also update wishlisted field in the products collection
      try {
        await _products.doc(docKey).update({'wishlisted': false});
      } catch (_) {}
    }
  }
}