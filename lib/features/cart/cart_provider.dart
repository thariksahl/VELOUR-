import 'package:flutter/material.dart';
import '../../data/app_data.dart';

/// Global cart state provider — tracks items + badge count for bottom nav.
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  // Track which product names have been added (for card icon colour)
  final Set<String> _addedProductNames = {};

  int get itemCount => _items.length;

  List<CartItem> get items => List.unmodifiable(_items);

  bool isInCart(String productName) => _addedProductNames.contains(productName);

  void addItem(CartItem item) {
    _items.add(item);
    _addedProductNames.add(item.name);
    // Also sync to legacy AppData list so CartScreen keeps working
    AppData.addToCart(item);
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _addedProductNames.remove(_items[index].name);
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    _addedProductNames.clear();
    notifyListeners();
  }
}
