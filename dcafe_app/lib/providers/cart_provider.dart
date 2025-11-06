import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (total, item) => total + item.quantity);

  double get totalAmount =>
      _items.fold(0.0, (total, item) => total + item.totalPrice);

  bool get isEmpty => _items.isEmpty;

  /// Add product to cart
  void addProduct(Product product) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].incrementQuantity();
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  /// Remove product from cart
  void removeProduct(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// Increment product quantity
  void incrementQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
    );
    item.incrementQuantity();
    notifyListeners();
  }

  /// Decrement product quantity
  void decrementQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
    );

    if (item.quantity > 1) {
      item.decrementQuantity();
    } else {
      removeProduct(productId);
    }
    notifyListeners();
  }

  /// Clear all items from cart
  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Get cart items in Poster API format
  List<Map<String, dynamic>> toOrderFormat() {
    return _items.map((item) => item.toJson()).toList();
  }
}
