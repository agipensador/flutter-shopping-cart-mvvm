import 'package:app_carrinho_de_compras/core/result/result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import '../../domain/cart_store.dart';
import '../../domain/models/cart_item.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/delete_item_confirmation_dialog.dart';
import 'cart_viewmodel.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Carrinho',
          style: AppTextStyles.title.copyWith(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Consumer2<CartStore, CartViewModel>(
          builder: (context, cartStore, viewModel, _) {
            if (cartStore.items.isEmpty) {
              return Center(
                child: Text(
                  'Carrinho vazio',
                  style: AppTextStyles.body.copyWith(color: Colors.white),
                ),
              );
            }
            return Column(
              children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartStore.items.length,
                  itemBuilder: (context, index) {
                    final item = cartStore.items[index];
                    return _CartItemTile(item: item);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.primary,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Itens: ${cartStore.totalItemCount}',
                          style: AppTextStyles.body.copyWith(color: Colors.white),
                        ),
                        Text(
                          'Subtotal: R\$ ${cartStore.total.toStringAsFixed(2)}',
                          style: AppTextStyles.body.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Total: R\$ ${cartStore.total.toStringAsFixed(2)}',
                          style: AppTextStyles.title.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Finalizar',
                      isLoading: viewModel.isCheckoutLoading,
                      onPressed: () async {
                              final result = await viewModel.checkout();
                              if (!context.mounted) return;
                              result.when(
                                success: (_) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRoutes.checkoutAnimation,
                                    (route) => route.isFirst,
                                  );
                                },
                                failure: (_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Ops, tente novamente'),
                                      backgroundColor: Colors.grey,
                                    ),
                                  );
                                },
                              );
                            },
                    ),
                  ],
                ),
              ),
            ],
            );
          },
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CartViewModel>();
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
                    'R\$ ${item.product.price.toStringAsFixed(2)} x ${item.quantity} = R\$ ${item.subtotal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (!viewModel.cartStore.isFinalized)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () async {
                          try {
                            await viewModel.decrementQuantity(item.product, item.quantity);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                              );
                            }
                          }
                        },
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          try {
                            await viewModel.incrementQuantity(item.product, item.quantity);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.secondary),
                    onPressed: () async {
                      final confirmed = await DeleteItemConfirmationDialog.show(
                        context,
                        item.product.title,
                      );
                      if (!context.mounted || confirmed != true) return;
                      try {
                        await viewModel.removeItem(item.product);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
