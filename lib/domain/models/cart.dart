import 'cart_item.dart';

class Cart {
  const Cart({
    required this.items,
    this.isFinalized = false,
  });

  final List<CartItem> items;
  final bool isFinalized;

  int get distinctCount => items.length;
  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get total => items.fold(0, (sum, item) => sum + item.subtotal);
}
