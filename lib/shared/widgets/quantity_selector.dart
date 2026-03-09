import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    this.onAddToCart,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    if (quantity == 0 && onAddToCart != null) {
      return TextButton(
        onPressed: onAddToCart,
        child: const Text('Adicionar\nao carrinho'),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: onDecrement,
        ),
        SizedBox(
          width: 32,
          child: Text(
            quantity.toString(),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: onIncrement,
        ),
      ],
    );
  }
}
