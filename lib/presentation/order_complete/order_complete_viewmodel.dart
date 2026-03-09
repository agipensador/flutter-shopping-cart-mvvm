import 'package:flutter/foundation.dart';

import '../../domain/cart_store.dart';
import '../../domain/models/cart_item.dart';
import '../cart/cart_viewmodel.dart';

class OrderCompleteViewModel extends ChangeNotifier {
  OrderCompleteViewModel({
    required CartStore cartStore,
    required CartViewModel cartViewModel,
  })  : _cartStore = cartStore,
        _cartViewModel = cartViewModel;

  final CartStore _cartStore;
  final CartViewModel _cartViewModel;

  List<CartItem> get items => _cartStore.items;
  double get subtotal => _cartStore.total;
  double get shipping => _cartViewModel.deliveryPrice;
  double get total => subtotal + shipping;
}
