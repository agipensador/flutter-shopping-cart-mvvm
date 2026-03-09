import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/result/result.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/helpers/snackbar_helper.dart';
import '../../domain/cart_store.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/cart_item_tile.dart';
import '../../shared/widgets/cep_bottom_sheet.dart';
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
                    return CartItemTile(item: item);
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
                                onCalculated: () => viewModel.setShippingCost(30),
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
                            if (viewModel.shippingCost > 0)
                              Text(
                                '+ R\$ ${viewModel.shippingCost.toStringAsFixed(2)}',
                                style: AppTextStyles.body.copyWith(color: Colors.white),
                              ),
                            Text(
                              'Total: R\$ ${(cartStore.total + viewModel.shippingCost).toStringAsFixed(2)}',
                              style: AppTextStyles.title.copyWith(color: Colors.white),
                            ),
                          ],
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
                                  SnackBarHelper.showNeutral(context, 'Ops, tente novamente');
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

