import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/models/cart_item.dart';
import '../../shared/helpers/price_helper.dart';
import '../../shared/widgets/app_button.dart';
import 'cart_viewmodel.dart';

class CheckoutConfirmationModal extends StatelessWidget {
  const CheckoutConfirmationModal({
    super.key,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.onBackToCart,
    required this.onContinue,
  });

  final List<CartItem> items;
  final double subtotal;
  final double shipping;
  final double total;
  final VoidCallback onBackToCart;
  final VoidCallback onContinue;

  static Future<void> show(
    BuildContext context, {
    required List<CartItem> items,
    required double subtotal,
    required double shipping,
    required double total,
    required VoidCallback onBackToCart,
    required VoidCallback onContinue,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CheckoutConfirmationModal(
        items: items,
        subtotal: subtotal,
        shipping: shipping,
        total: total,
        onBackToCart: onBackToCart,
        onContinue: onContinue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Confirme seu pedido',
              style: AppTextStyles.title.copyWith(color: AppColors.primary),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return _OrderReviewTile(item: items[index]);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Consumer<CartViewModel>(
                      builder: (context, viewModel, _) {
                        final isLoading = viewModel.isCheckoutLoading;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: AppTextStyles.title.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  PriceHelper.format(total),
                                  style: AppTextStyles.title.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            AppButton(
                              label: 'Voltar para o carrinho',
                              backgroundColor: AppColors.primary,
                              onPressed: isLoading ? null : onBackToCart,
                            ),
                            const SizedBox(height: 12),
                            AppButton(
                              label: 'Confirmar pedido',
                              isLoading: isLoading,
                              onPressed: isLoading ? null : onContinue,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderReviewTile extends StatelessWidget {
  const _OrderReviewTile({required this.item});

  final CartItem item;

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
            Container(
              width: 48,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 2, color: AppColors.primary),
                ),
              ),
              child: Center(
                child: Text(
                  item.quantity.toString(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
