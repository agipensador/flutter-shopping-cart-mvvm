import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.trailing,
  });

  final Product product;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: null,
        leading: Image.network(
          product.imageUrl,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
        ),
        title: Text(product.title),
        subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
        trailing: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(width: 2, color: AppColors.primary),
            ),
          ),
          child: trailing,
        ),
      ),
    );
  }
}
