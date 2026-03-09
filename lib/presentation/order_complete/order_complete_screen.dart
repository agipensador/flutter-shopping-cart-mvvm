import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import '../../domain/cart_store.dart';
import '../../shared/widgets/app_button.dart';

class OrderCompleteScreen extends StatelessWidget {
  const OrderCompleteScreen({super.key});

  void _goToCatalogWithEmptyCart(BuildContext context) {
    context.read<CartStore>().clear();
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Parabéns, seu pedido foi concluído com sucesso',
                  style: AppTextStyles.title.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  'Pode ficar tranquilo, já estamos enviando seu pedido para seu endereço!\n\nClique no botão abaixo para seguir para nosso catálogo!',
                  style: AppTextStyles.body.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                AppButton(
                  label: 'Novo pedido',
                  onPressed: () => _goToCatalogWithEmptyCart(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
