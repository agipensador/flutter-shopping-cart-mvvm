import 'package:flutter/material.dart';

import '../../presentation/catalog/catalog_screen.dart';
import '../../presentation/cart/cart_screen.dart';
import '../../presentation/checkout_animation/checkout_animation_screen.dart';
import '../../presentation/order_complete/order_complete_screen.dart';

abstract final class AppRoutes {
  static const String catalog = '/';
  static const String cart = '/cart';
  static const String checkoutAnimation = '/checkout-animation';
  static const String orderComplete = '/order-complete';

  static Map<String, WidgetBuilder> get routes => {
        catalog: (_) => const CatalogScreen(),
        cart: (_) => const CartScreen(),
        checkoutAnimation: (_) => const CheckoutAnimationScreen(),
        orderComplete: (_) => const OrderCompleteScreen(),
      };
}
