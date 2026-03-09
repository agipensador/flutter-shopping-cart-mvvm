import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/models/cart_item.dart';
import '../helpers/price_helper.dart';
import 'quantity_selector.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
  });

  final CartItem item;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRemove;

  bool get _isEditable =>
      onIncrement != null && onDecrement != null && onRemove != null;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              item.product.imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.product.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${PriceHelper.format(item.product.price)} x ${item.quantity} = ${PriceHelper.format(item.subtotal)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (_isEditable) ...[
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QuantitySelector(
                    quantity: item.quantity,
                    onDecrement: onDecrement!,
                    onIncrement: onIncrement!,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onRemove,
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
