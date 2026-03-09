import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/result/result.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/helpers/price_helper.dart';
import '../../shared/helpers/snackbar_helper.dart';
import '../../domain/cart_store.dart';
import '../../domain/models/cart_item.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/cart_item_tile.dart';
import '../../shared/widgets/cep_bottom_sheet.dart';
import '../../shared/widgets/delete_item_confirmation_dialog.dart';
import 'cart_viewmodel.dart';
import 'checkout_confirmation_modal.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
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
                  style: AppTextStyles.body,
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
                    return CartItemTile(
                      item: item,
                      onIncrement: () => _incrementItem(context, viewModel, item),
                      onDecrement: () => _decrementItem(context, viewModel, item),
                      onRemove: () => _removeItem(context, viewModel, item),
                    );
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
                          style: AppTextStyles.body,
                        ),
                        Text(
                          'Subtotal: ${PriceHelper.format(cartStore.total)}',
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 140,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              CepBottomSheet.show(
                                context,
                                onCalculated: () => viewModel.setDeliveryPrice(30),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tertiary,
                              foregroundColor: Colors.white,
                              side: const BorderSide(width: 2),
                              shadowColor: Colors.transparent,
                            ),
                            child: const Text('Calcular CEP'),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (viewModel.deliveryPrice > 0)
                              Text(
                                '+ ${PriceHelper.format(viewModel.deliveryPrice)}',
                                style: AppTextStyles.body,
                              ),
                            Text(
                              'Total: ${PriceHelper.format(cartStore.total + viewModel.deliveryPrice)}',
                              style: AppTextStyles.title,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Finalizar',
                      onPressed: () => _openCheckoutModal(
                        context,
                        cartStore,
                        viewModel,
                      ),
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

  Future<void> _incrementItem(
    BuildContext context,
    CartViewModel viewModel,
    CartItem item,
  ) async {
    try {
      await viewModel.incrementQuantity(item.product, item.quantity);
    } catch (e) {
      if (context.mounted) {
        SnackBarHelper.showError(
          context,
          e.toString().replaceFirst('Exception: ', ''),
        );
      }
    }
  }

  Future<void> _decrementItem(
    BuildContext context,
    CartViewModel viewModel,
    CartItem item,
  ) async {
    if (item.quantity == 1) {
      final confirmed = await DeleteItemConfirmationDialog.show(
        context,
        item.product.title,
      );
      if (!context.mounted || confirmed != true) return;
    }
    try {
      await viewModel.decrementQuantity(item.product, item.quantity);
    } catch (e) {
      if (context.mounted) {
        SnackBarHelper.showError(
          context,
          e.toString().replaceFirst('Exception: ', ''),
        );
      }
    }
  }

  void _openCheckoutModal(
    BuildContext context,
    CartStore cartStore,
    CartViewModel viewModel,
  ) {
    CheckoutConfirmationModal.show(
      context,
      items: cartStore.items,
      subtotal: cartStore.total,
      shipping: viewModel.deliveryPrice,
      total: cartStore.total + viewModel.deliveryPrice,
      onBackToCart: () => Navigator.pop(context),
      onContinue: () => _runCheckout(context, viewModel),
    );
  }

  Future<void> _runCheckout(
    BuildContext context,
    CartViewModel viewModel,
  ) async {
    final result = await viewModel.checkout();
    if (!context.mounted) return;
    result.when(
      success: (_) {
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.checkoutAnimation,
          (route) => route.isFirst,
        );
      },
      failure: (error) {
        SnackBarHelper.showError(context, error);
      },
    );
  }

  Future<void> _removeItem(
    BuildContext context,
    CartViewModel viewModel,
    CartItem item,
  ) async {
    final confirmed = await DeleteItemConfirmationDialog.show(
      context,
      item.product.title,
    );
    if (!context.mounted || confirmed != true) return;
    try {
      await viewModel.removeItem(item.product);
    } catch (e) {
      if (context.mounted) {
        SnackBarHelper.showError(
          context,
          e.toString().replaceFirst('Exception: ', ''),
        );
      }
    }
  }
}

