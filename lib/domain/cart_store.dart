import 'package:flutter/foundation.dart';

import 'models/cart_item.dart';
import 'models/product.dart';

class CartStore extends ChangeNotifier {
  static const int _maxDifferentProducts = 10;

  final List<CartItem> _items = [];
  bool _isFinalized = false;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isFinalized => _isFinalized;
  int get distinctCount => _items.length;

  int getQuantity(int productId) {
    final item = _items.where((e) => e.product.id == productId).firstOrNull;
    return item?.quantity ?? 0;
  }

  bool canAddProduct(int productId) {
    if (_isFinalized) return false;
    if (getQuantity(productId) > 0) return true;
    return _items.length < _maxDifferentProducts;
  }

  void addItem(Product product, int quantity) {
    if (_isFinalized) return;
    final index = _items.indexWhere((e) => e.product.id == product.id);
    if (index >= 0) {
      _items[index] = CartItem(product: product, quantity: _items[index].quantity + quantity);
    } else {
      if (_items.length >= _maxDifferentProducts) return;
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    if (_isFinalized) return;
    final index = _items.indexWhere((e) => e.product.id == productId);
    if (index < 0) return;
    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] = CartItem(product: _items[index].product, quantity: quantity);
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    if (_isFinalized) return;
    _items.removeWhere((e) => e.product.id == productId);
    notifyListeners();
  }

  void finalize() {
    _isFinalized = true;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _isFinalized = false;
    notifyListeners();
  }

  double get total => _items.fold(0, (sum, item) => sum + item.subtotal);
  int get totalItemCount => _items.fold(0, (sum, item) => sum + item.quantity);
}
