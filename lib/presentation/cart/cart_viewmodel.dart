import 'package:flutter/foundation.dart';

import '../../data/services/cart_api.dart';
import '../../domain/cart_store.dart';
import '../../domain/models/product.dart';

class CartViewModel extends ChangeNotifier {
  CartViewModel({
    CartApi? cartApi,
    CartStore? cartStore,
  })  : _cartApi = cartApi ?? CartApi(),
        _cartStore = cartStore ?? CartStore();

  final CartApi _cartApi;
  final CartStore _cartStore;

  CartStore get cartStore => _cartStore;

  Future<void> incrementQuantity(Product product, int currentQuantity) async {
    if (_cartStore.isFinalized) return;
    await _cartApi.updateQuantity(product.id, currentQuantity + 1);
    _cartStore.updateQuantity(product.id, currentQuantity + 1);
  }

  Future<void> decrementQuantity(Product product, int currentQuantity) async {
    if (_cartStore.isFinalized) return;
    if (currentQuantity <= 1) {
      await _cartApi.removeItem(product.id);
      _cartStore.removeItem(product.id);
      return;
    }
    await _cartApi.updateQuantity(product.id, currentQuantity - 1);
    _cartStore.updateQuantity(product.id, currentQuantity - 1);
  }

  Future<void> removeItem(Product product) async {
    if (_cartStore.isFinalized) return;
    await _cartApi.removeItem(product.id);
    _cartStore.removeItem(product.id);
  }
}
