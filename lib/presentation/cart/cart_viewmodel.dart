import 'package:flutter/foundation.dart';

import '../../core/result/result.dart';
import '../../data/services/cart_api.dart';
import '../../data/services/checkout_api.dart';
import '../../domain/cart_store.dart';
import '../../domain/models/product.dart';

class CartViewModel extends ChangeNotifier {
  CartViewModel({
    CartApi? cartApi,
    CheckoutApi? checkoutApi,
    CartStore? cartStore,
  })  : _cartApi = cartApi ?? CartApi(),
        _checkoutApi = checkoutApi ?? CheckoutApi(),
        _cartStore = cartStore ?? CartStore();

  final CartApi _cartApi;
  final CheckoutApi _checkoutApi;
  final CartStore _cartStore;

  CartStore get cartStore => _cartStore;
  bool _isCheckoutLoading = false;
  bool get isCheckoutLoading => _isCheckoutLoading;

  Future<void> incrementQuantity(Product product, int currentQuantity) async {
    if (_cartStore.isFinalized) return;
    final result = await _cartApi.updateQuantity(product.id, currentQuantity + 1);
    result.when(
      success: (_) => _cartStore.updateQuantity(product.id, currentQuantity + 1),
      failure: (error) => throw Exception(error),
    );
  }

  Future<void> decrementQuantity(Product product, int currentQuantity) async {
    if (_cartStore.isFinalized) return;
    if (currentQuantity <= 1) {
      final result = await _cartApi.removeItem(product.id);
      result.when(
        success: (_) => _cartStore.removeItem(product.id),
        failure: (error) => throw Exception(error),
      );
      return;
    }
    final result = await _cartApi.updateQuantity(product.id, currentQuantity - 1);
    result.when(
      success: (_) => _cartStore.updateQuantity(product.id, currentQuantity - 1),
      failure: (error) => throw Exception(error),
    );
  }

  Future<void> removeItem(Product product) async {
    if (_cartStore.isFinalized) return;
    final result = await _cartApi.removeItem(product.id);
    result.when(
      success: (_) => _cartStore.removeItem(product.id),
      failure: (error) => throw Exception(error),
    );
  }

  Future<Result<bool>> checkout() async {
    _isCheckoutLoading = true;
    notifyListeners();

    final result = await _checkoutApi.checkout();
    _isCheckoutLoading = false;

    if (result.isSuccess) {
      _cartStore.finalize();
    }
    notifyListeners();
    return result;
  }
}
