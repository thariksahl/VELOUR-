import 'package:flutter/material.dart';

/// Shared product model used across Home, ProductList, and Explore screens.
class Product {
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  final String category;
  bool wishlisted;

  Product({
    required this.name,
    this.description = '',
    required this.price,
    required this.imageUrl,
    this.category = 'MEN', // Default category for safety
    this.wishlisted = false,
  });
}

/// Category chip model (e.g., NEW IN, MEN, WOMEN).
class Category {
  final String label;
  const Category(this.label);
}

/// Sub-category with circular image (e.g., SHIRTS, JEANS).
class SubCategory {
  final String label;
  final String imageUrl;
  const SubCategory(this.label, this.imageUrl);
}

/// Explore screen main category card.
class ExploreCategory {
  final String title;
  final String subtitle;
  final String imageUrl;
  const ExploreCategory({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

/// Curated series item for Explore screen.
class CuratedSeries {
  final String id;
  final String title;
  const CuratedSeries({required this.id, required this.title});
}

/// Cart item model.
class CartItem {
  final String name;
  final String variant;
  final String price;
  final String imageUrl;
  int qty;
  CartItem(this.name, this.variant, this.price, this.imageUrl, {this.qty = 1});
}

/// Notification item model.
class NotificationItem {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final String time;
  final bool isUnread;
  final bool isFadedText;

  const NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isUnread,
    required this.isFadedText,
  });
}

/// Order summary item.
class OrderSummaryItem {
  final String name;
  final String variant;
  final String price;
  final String imageUrl;
  const OrderSummaryItem({
    required this.name,
    required this.variant,
    required this.price,
    required this.imageUrl,
  });
}
