import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'app_data.dart';

/// One-time data migration: uploads all products from [AppData.products()]
/// to the Firestore 'products' collection.
///
/// • Each document uses the product index as its ID: `product_0`, `product_1` …
/// • A sentinel document `_migration/products_seeded` is written after a
///   successful run so the function is a no-op on subsequent cold-starts.
/// • Call this once from main() **before** [runApp].
Future<void> migrateProductsToFirestore() async {
  final firestore = FirebaseFirestore.instance;

  // ── Guard: skip if already seeded ────────────────────────────────────────
  final sentinelRef =
      firestore.collection('_migration').doc('products_seeded');
  final sentinel = await sentinelRef.get();
  if (sentinel.exists) {
    debugPrint('⏭  Products already seeded — skipping migration.');
    return;
  }

  // ── Upload ────────────────────────────────────────────────────────────────
  final products = AppData.products();

  // Firestore batch limit is 500 writes; split if needed.
  const chunkSize = 400;
  int uploaded = 0;

  for (int start = 0; start < products.length; start += chunkSize) {
    final end =
        (start + chunkSize < products.length) ? start + chunkSize : products.length;
    final batch = firestore.batch();

    for (int i = start; i < end; i++) {
      final p = products[i];
      // Use product index as the Firestore document ID.
      final docRef = firestore.collection('products').doc('product_$i');
      batch.set(docRef, {
        'id': 'product_$i',
        'name': p.name,
        'description': p.description,
        'price': p.price,
        'imageUrl': p.imageUrl,
        'category': p.category,
        'wishlisted': false,
        'colorVariants': p.colorVariants
            .map((cv) => {
                  'name': cv.name,
                  'imageUrl': cv.imageUrl,
                  // Store color as an ARGB int so Firestore can hold it
                  'colorValue': cv.color.toARGB32(),
                })
            .toList(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    // Write sentinel in the last batch
    if (end == products.length) {
      batch.set(sentinelRef, {
        'seededAt': FieldValue.serverTimestamp(),
        'count': products.length,
      });
    }

    await batch.commit();
    uploaded += (end - start);
  }

  debugPrint('✅ Upload complete — $uploaded products written to Firestore.');
  print('Upload complete');
}
