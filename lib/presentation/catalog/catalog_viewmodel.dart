import 'package:flutter/foundation.dart';

import '../../data/services/cart_api.dart';
import '../../data/services/products_api.dart';
import '../../domain/cart_store.dart';
import '../../domain/models/product.dart';

class CatalogViewModel extends ChangeNotifier {
  CatalogViewModel({
    ProductsApi? api,
    CartApi? cartApi,
    CartStore? cartStore,
  })  : _api = api ?? ProductsApi(),
        _cartApi = cartApi ?? CartApi(),
        _cartStore = cartStore ?? CartStore();

  final ProductsApi _api;
  final CartApi _cartApi;
  final CartStore _cartStore;

  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get error => _error;
  CartStore get cartStore => _cartStore;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _api.getProducts();
      _error = null;
    } catch (e) {
      _products = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart(Product product) async {
    if (!_cartStore.canAddProduct(product.id)) {
      return false;
    }
    try {
      await _cartApi.addItem(product.id, 1);
      _cartStore.addItem(product, 1);
      return true;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> incrementQuantity(Product product) async {
    if (!_cartStore.canAddProduct(product.id)) {
      return false;
    }
    final currentQty = _cartStore.getQuantity(product.id);
    if (currentQty == 0) {
      return addToCart(product);
    }
    try {
      await _cartApi.updateQuantity(product.id, currentQty + 1);
      _cartStore.updateQuantity(product.id, currentQty + 1);
      return true;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> decrementQuantity(Product product) async {
    final currentQty = _cartStore.getQuantity(product.id);
    if (currentQty <= 0) return;
    if (currentQty == 1) {
      await _cartApi.removeItem(product.id);
      _cartStore.removeItem(product.id);
      return;
    }
    await _cartApi.updateQuantity(product.id, currentQty - 1);
    _cartStore.updateQuantity(product.id, currentQty - 1);
  }
}

