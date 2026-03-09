import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/helpers/price_helper.dart';
import '../../core/routes/app_routes.dart';
import '../../domain/cart_store.dart';
import '../cart/cart_viewmodel.dart';
import 'order_complete_viewmodel.dart';
import '../../shared/widgets/app_button.dart';

class OrderCompleteScreen extends StatelessWidget {
  const OrderCompleteScreen({super.key});

  void _goToCatalogWithEmptyCart(BuildContext context) {
    context.read<CartStore>().clear();
    context.read<CartViewModel>().clearShipping();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.catalog,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _goToCatalogWithEmptyCart(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _goToCatalogWithEmptyCart(context),
          ),
          title: Text(
            'Pedido Concluído!',
            style: AppTextStyles.title.copyWith(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: Consumer<OrderCompleteViewModel>(
            builder: (context, viewModel, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Parabéns, seu pedido foi concluído com sucesso',
                      style: AppTextStyles.title,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pode ficar tranquilo, já estamos enviando seu pedido para seu endereço!',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _ResumoSection(
                      subtotal: viewModel.subtotal,
                      shipping: viewModel.shipping,
                      total: viewModel.total,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Clique no botão abaixo para seguir para nosso catálogo!',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'Novo pedido',
                      onPressed: () => _goToCatalogWithEmptyCart(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ResumoSection extends StatelessWidget {
  const _ResumoSection({
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  final double subtotal;
  final double shipping;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal:',
                style: AppTextStyles.body,
              ),
              Text(
                PriceHelper.format(subtotal),
                style: AppTextStyles.body,
              ),
            ],
          ),
          if (shipping > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Frete:',
                  style: AppTextStyles.body,
                ),
                Text(
                  PriceHelper.format(shipping),
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: AppTextStyles.title,
              ),
              Text(
                PriceHelper.format(total),
                style: AppTextStyles.title,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
