import 'package:app_carrinho_de_compras/core/result/result.dart';
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

    final result = await _api.getProducts();
    result.when(
      success: (data) {
        _products = data;
        _error = null;
      },
      failure: (error) {
        _products = [];
        _error = error;
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addToCart(Product product) async {
    if (!_cartStore.canAddProduct(product.id)) {
      return false;
    }
    final result = await _cartApi.addItem(product.id, 1);
    return result.when(
      success: (_) {
        _cartStore.addItem(product, 1);
        return true;
      },
      failure: (error) => throw Exception(error),
    );
  }

  Future<bool> incrementQuantity(Product product) async {
    if (!_cartStore.canAddProduct(product.id)) {
      return false;
    }
    final currentQty = _cartStore.getQuantity(product.id);
    if (currentQty == 0) {
      return addToCart(product);
    }
    final result = await _cartApi.updateQuantity(product.id, currentQty + 1);
    return result.when(
      success: (_) {
        _cartStore.updateQuantity(product.id, currentQty + 1);
        return true;
      },
      failure: (error) => throw Exception(error),
    );
  }

  Future<void> decrementQuantity(Product product) async {
    final currentQty = _cartStore.getQuantity(product.id);
    if (currentQty <= 0) return;
    if (currentQty == 1) {
      final result = await _cartApi.removeItem(product.id);
      result.when(
        success: (_) => _cartStore.removeItem(product.id),
        failure: (error) => throw Exception(error),
      );
      return;
    }
    final result = await _cartApi.updateQuantity(product.id, currentQty - 1);
    result.when(
      success: (_) => _cartStore.updateQuantity(product.id, currentQty - 1),
      failure: (error) => throw Exception(error),
    );
  }
}

